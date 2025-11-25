<?php

abstract class WP_Commander_Base_Controller {
    
    protected $namespace = 'wp-commander/v1';
    protected $rest_base = '';
    
    abstract public function register_routes();
    
    protected function check_permission() {
        $api_key = $this->get_api_key_from_header();
        
        if (!$api_key) {
            return new WP_Error(
                'rest_forbidden',
                'API key missing',
                array('status' => 401)
            );
        }
        
        $saved_key = get_option('wp_commander_api_key');
        
        if (!$saved_key || !hash_equals($saved_key, $api_key)) {
            return new WP_Error(
                'rest_forbidden',
                'Invalid API key',
                array('status' => 401)
            );
        }
        
        return true;
    }
    
    private function get_api_key_from_header() {
        $headers = getallheaders();
        
        // Chercher la clé API dans les headers
        foreach ($headers as $key => $value) {
            if (strtolower($key) === 'x-wpc-api-key') {
                return sanitize_text_field($value);
            }
        }
        
        // Fallback pour $_SERVER
        if (isset($_SERVER['HTTP_X_WPC_API_KEY'])) {
            return sanitize_text_field($_SERVER['HTTP_X_WPC_API_KEY']);
        }
        
        return false;
    }
    
    protected function success_response($data = array(), $message = 'Success') {
        return rest_ensure_response(array(
            'success' => true,
            'message' => $message,
            'data' => $data,
            'timestamp' => current_time('c'),
        ));
    }
    
    protected function error_response($message = 'Error', $code = 'error', $status = 400) {
        return new WP_Error($code, $message, array('status' => $status));
    }
    
    protected function get_cached_data($key, $callback, $expiration = 300) {
        $transient_key = 'wp_commander_' . $key;
        $data = get_transient($transient_key);
        
        if ($data === false) {
            $data = $callback();
            set_transient($transient_key, $data, $expiration);
        }
        
        return $data;
    }
    
    protected function clear_cache($key) {
        $transient_key = 'wp_commander_' . $key;
        delete_transient($transient_key);
    }
}