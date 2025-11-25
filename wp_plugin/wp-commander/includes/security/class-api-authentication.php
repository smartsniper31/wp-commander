<?php

class WP_Commander_API_Authentication {
    
    private $rate_limit_interval = 60; // 60 secondes
    private $rate_limit_max_requests = 100; // 100 requêtes par minute
    
    public function __construct() {
        add_filter('rest_authentication_errors', array($this, 'check_authentication'), 20);
        add_action('rest_api_init', array($this, 'add_rate_limiting'));
    }
    
    public function check_authentication($result) {
        // Si l'authentification a déjà échoué, retourner l'erreur
        if (!empty($result)) {
            return $result;
        }
        
        // Vérifier si c'est une route de notre API
        if (!$this->is_commander_route()) {
            return $result;
        }
        
        // Vérifier la clé API
        $api_key = $this->get_api_key_from_header();
        
        if (!$api_key) {
            return new WP_Error(
                'rest_forbidden',
                'API key required',
                array('status' => 401)
            );
        }
        
        $saved_key = get_option('wp_commander_api_key');
        
        if (!$saved_key || !hash_equals($saved_key, $api_key)) {
            $this->log_failed_attempt();
            return new WP_Error(
                'rest_forbidden',
                'Invalid API key',
                array('status' => 401)
            );
        }
        
        // Vérifier si le plugin est activé
        if (get_option('wp_commander_enabled') !== 'yes') {
            return new WP_Error(
                'rest_forbidden',
                'WP Commander is disabled',
                array('status' => 403)
            );
        }
        
        return $result;
    }
    
    public function add_rate_limiting() {
        add_filter('rest_pre_dispatch', array($this, 'check_rate_limit'), 10, 3);
    }
    
    public function check_rate_limit($result, $server, $request) {
        if (!$this->is_commander_route()) {
            return $result;
        }
        
        $client_ip = $this->get_client_ip();
        $rate_limit_key = 'wp_commander_rate_limit_' . $client_ip;
        
        $requests = get_transient($rate_limit_key);
        
        if ($requests === false) {
            $requests = 0;
            set_transient($rate_limit_key, 1, $this->rate_limit_interval);
        } else {
            $requests++;
            set_transient($rate_limit_key, $requests, $this->rate_limit_interval);
        }
        
        if ($requests > $this->rate_limit_max_requests) {
            return new WP_Error(
                'rate_limit_exceeded',
                'Rate limit exceeded. Please try again later.',
                array('status' => 429)
            );
        }
        
        return $result;
    }
    
    private function is_commander_route() {
        $request_uri = $_SERVER['REQUEST_URI'] ?? '';
        return strpos($request_uri, '/wp-json/wp-commander/') !== false;
    }
    
    private function get_api_key_from_header() {
        $headers = getallheaders();
        
        foreach ($headers as $key => $value) {
            if (strtolower($key) === 'x-wpc-api-key') {
                return sanitize_text_field($value);
            }
        }
        
        if (isset($_SERVER['HTTP_X_WPC_API_KEY'])) {
            return sanitize_text_field($_SERVER['HTTP_X_WPC_API_KEY']);
        }
        
        return false;
    }
    
    private function get_client_ip() {
        $ip_keys = array(
            'HTTP_X_FORWARDED_FOR',
            'HTTP_X_REAL_IP',
            'HTTP_CLIENT_IP',
            'REMOTE_ADDR'
        );
        
        foreach ($ip_keys as $key) {
            if (!empty($_SERVER[$key])) {
                $ip = $_SERVER[$key];
                if (strpos($ip, ',') !== false) {
                    $ips = explode(',', $ip);
                    $ip = trim($ips[0]);
                }
                if (filter_var($ip, FILTER_VALIDATE_IP)) {
                    return $ip;
                }
            }
        }
        
        return '0.0.0.0';
    }
    
    private function log_failed_attempt() {
        $log_data = array(
            'timestamp' => current_time('mysql'),
            'ip' => $this->get_client_ip(),
            'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? 'Unknown',
            'endpoint' => $_SERVER['REQUEST_URI'] ?? 'Unknown',
        );
        
        $failed_attempts = get_option('wp_commander_failed_attempts', array());
        $failed_attempts[] = $log_data;
        
        // Garder seulement les 100 dernières tentatives
        if (count($failed_attempts) > 100) {
            $failed_attempts = array_slice($failed_attempts, -100);
        }
        
        update_option('wp_commander_failed_attempts', $failed_attempts, false);
    }
}

// Initialiser l'authentification
new WP_Commander_API_Authentication();