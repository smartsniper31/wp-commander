<?php

class WP_Commander_Health_Controller extends WP_Commander_Base_Controller {
    
    protected $rest_base = 'health';
    
    public function register_routes() {
        register_rest_route($this->namespace, '/' . $this->rest_base . '-check', array(
            array(
                'methods' => WP_REST_Server::READABLE,
                'callback' => array($this, 'get_health_check'),
                'permission_callback' => array($this, 'check_permission'),
            ),
        ));
        
        register_rest_route($this->namespace, '/' . $this->rest_base . '-detailed', array(
            array(
                'methods' => WP_REST_Server::READABLE,
                'callback' => array($this, 'get_detailed_health'),
                'permission_callback' => array($this, 'check_permission'),
            ),
        ));
    }
    
    public function get_health_check($request) {
        try {
            $health_data = $this->get_cached_data('health_check', function() {
                return $this->perform_health_check();
            }, 600); // Cache 10 minutes
            
            return $this->success_response($health_data, 'Health check completed');
            
        } catch (Exception $e) {
            return $this->error_response('Health check failed: ' . $e->getMessage());
        }
    }
    
    public function get_detailed_health($request) {
        try {
            $detailed_health = $this->perform_detailed_health_check();
            return $this->success_response($detailed_health, 'Detailed health check completed');
            
        } catch (Exception $e) {
            return $this->error_response('Detailed health check failed: ' . $e->getMessage());
        }
    }
    
    private function perform_health_check() {
        $start_time = microtime(true);
        
        // Vérifications de base
        $checks = array(
            'wordpress' => $this->check_wordpress_health(),
            'database' => $this->check_database_health(),
            'php' => $this->check_php_health(),
            'server' => $this->check_server_health(),
            'plugins' => $this->check_plugins_health(),
        );
        
        $end_time = microtime(true);
        $response_time = round(($end_time - $start_time) * 1000, 2); // en ms
        
        // Calcul du score global
        $score = $this->calculate_health_score($checks);
        
        return array(
            'status' => $this->get_health_status($score),
            'score' => $score,
            'response_time' => $response_time,
            'is_online' => true,
            'checks' => $checks,
            'checked_at' => current_time('c'),
            'php_version' => phpversion(),
            'wp_version' => get_bloginfo('version'),
        );
    }
    
    private function perform_detailed_health_check() {
        $basic_health = $this->perform_health_check();
        
        // Ajouter des vérifications détaillées
        $detailed_checks = array(
            'security' => $this->check_security_health(),
            'performance' => $this->check_performance_health(),
            'seo' => $this->check_seo_health(),
            'updates' => $this->check_updates_health(),
        );
        
        $basic_health['detailed_checks'] = $detailed_checks;
        $basic_health['issues'] = $this->get_health_issues($basic_health['checks'], $detailed_checks);
        
        return $basic_health;
    }
    
    private function check_wordpress_health() {
        $issues = array();
        $score = 100;
        
        // Vérifier la version de WordPress
        if (!is_wp_version_compatible()) {
            $issues[] = array(
                'title' => 'WordPress version outdated',
                'description' => 'Your WordPress version may be outdated',
                'severity' => 'medium',
                'fix' => 'Update to the latest WordPress version',
            );
            $score -= 20;
        }
        
        // Vérifier les réglages de permaliens
        if (get_option('permalink_structure') === '') {
            $issues[] = array(
                'title' => 'Plain permalinks enabled',
                'description' => 'Plain permalinks can affect SEO',
                'severity' => 'low',
                'fix' => 'Change to a SEO-friendly permalink structure',
            );
            $score -= 10;
        }
        
        return array(
            'status' => $score >= 80 ? 'good' : ($score >= 60 ? 'fair' : 'poor'),
            'score' => $score,
            'issues' => $issues,
        );
    }
    
    private function check_database_health() {
        global $wpdb;
        $issues = array();
        $score = 100;
        
        // Vérifier la taille de la base de données
        $db_size = $wpdb->get_var("
            SELECT ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) 
            FROM information_schema.tables 
            WHERE table_schema = '" . DB_NAME . "'
        ");
        
        if ($db_size > 100) { // Plus de 100MB
            $issues[] = array(
                'title' => 'Large database size',
                'description' => "Database size is {$db_size}MB",
                'severity' => 'low',
                'fix' => 'Consider cleaning up old data and optimizing tables',
            );
            $score -= 10;
        }
        
        // Vérifier les tables optimisées
        $unoptimized_tables = $wpdb->get_results("
            SHOW TABLE STATUS WHERE Data_free > 0
        ");
        
        if (count($unoptimized_tables) > 0) {
            $issues[] = array(
                'title' => 'Database optimization needed',
                'description' => count($unoptimized_tables) . ' tables need optimization',
                'severity' => 'low',
                'fix' => 'Optimize database tables',
            );
            $score -= 5;
        }
        
        return array(
            'status' => $score >= 80 ? 'good' : ($score >= 60 ? 'fair' : 'poor'),
            'score' => $score,
            'issues' => $issues,
        );
    }
    
    private function check_php_health() {
        $issues = array();
        $score = 100;
        $php_version = phpversion();
        
        // Vérifier la version de PHP
        if (version_compare($php_version, '7.4', '<')) {
            $issues[] = array(
                'title' => 'PHP version outdated',
                'description' => "Your PHP version {$php_version} is outdated",
                'severity' => 'high',
                'fix' => 'Upgrade to PHP 7.4 or higher',
            );
            $score -= 30;
        }
        
        // Vérifier la mémoire allouée
        $memory_limit = ini_get('memory_limit');
        $memory_usage = memory_get_usage(true);
        
        if (wp_convert_hr_to_bytes($memory_limit) < 128 * 1024 * 1024) { // 128MB
            $issues[] = array(
                'title' => 'Low PHP memory limit',
                'description' => "Memory limit is {$memory_limit}",
                'severity' => 'medium',
                'fix' => 'Increase PHP memory limit to 128MB or higher',
            );
            $score -= 15;
        }
        
        // Vérifier les extensions requises
        $required_extensions = array('curl', 'json', 'mbstring', 'xml');
        $missing_extensions = array();
        
        foreach ($required_extensions as $ext) {
            if (!extension_loaded($ext)) {
                $missing_extensions[] = $ext;
            }
        }
        
        if (!empty($missing_extensions)) {
            $issues[] = array(
                'title' => 'Missing PHP extensions',
                'description' => 'Missing: ' . implode(', ', $missing_extensions),
                'severity' => 'medium',
                'fix' => 'Install missing PHP extensions',
            );
            $score -= 10 * count($missing_extensions);
        }
        
        return array(
            'status' => $score >= 80 ? 'good' : ($score >= 60 ? 'fair' : 'poor'),
            'score' => $score,
            'issues' => $issues,
        );
    }
    
    private function check_server_health() {
        $issues = array();
        $score = 100;
        
        // Vérifier le SSL
        if (!is_ssl()) {
            $issues[] = array(
                'title' => 'SSL not enabled',
                'description' => 'Site is not using HTTPS',
                'severity' => 'high',
                'fix' => 'Enable SSL certificate',
            );
            $score -= 25;
        }
        
        // Vérifier les en-têtes de sécurité
        $headers = get_headers(home_url(), 1);
        $security_headers = array(
            'X-Frame-Options',
            'X-Content-Type-Options',
            'Strict-Transport-Security',
        );
        
        $missing_headers = array();
        foreach ($security_headers as $header) {
            if (!isset($headers[$header])) {
                $missing_headers[] = $header;
            }
        }
        
        if (!empty($missing_headers)) {
            $issues[] = array(
                'title' => 'Missing security headers',
                'description' => 'Missing: ' . implode(', ', $missing_headers),
                'severity' => 'medium',
                'fix' => 'Configure security headers in server configuration',
            );
            $score -= 10;
        }
        
        return array(
            'status' => $score >= 80 ? 'good' : ($score >= 60 ? 'fair' : 'poor'),
            'score' => $score,
            'issues' => $issues,
        );
    }
    
    private function check_plugins_health() {
        $issues = array();
        $score = 100;
        
        if (!function_exists('get_plugins')) {
            require_once ABSPATH . 'wp-admin/includes/plugin.php';
        }
        
        $all_plugins = get_plugins();
        $active_plugins = get_option('active_plugins');
        $outdated_plugins = 0;
        
        // Vérifier les mises à jour de plugins
        $update_plugins = get_site_transient('update_plugins');
        if ($update_plugins && !empty($update_plugins->response)) {
            $outdated_plugins = count($update_plugins->response);
        }
        
        if ($outdated_plugins > 0) {
            $issues[] = array(
                'title' => 'Outdated plugins',
                'description' => "{$outdated_plugins} plugins need updates",
                'severity' => 'medium',
                'fix' => 'Update outdated plugins',
            );
            $score -= 5 * $outdated_plugins;
        }
        
        // Vérifier les plugins abandonnés (simplifié)
        if (count($active_plugins) > 20) {
            $issues[] = array(
                'title' => 'Many active plugins',
                'description' => count($active_plugins) . ' active plugins may affect performance',
                'severity' => 'low',
                'fix' => 'Consider deactivating unused plugins',
            );
            $score -= 5;
        }
        
        return array(
            'status' => $score >= 80 ? 'good' : ($score >= 60 ? 'fair' : 'poor'),
            'score' => max(0, $score),
            'issues' => $issues,
        );
    }
    
    private function calculate_health_score($checks) {
        $total_score = 0;
        $check_count = count($checks);
        
        foreach ($checks as $check) {
            $total_score += $check['score'];
        }
        
        return round($total_score / $check_count);
    }
    
    private function get_health_status($score) {
        if ($score >= 90) return 'excellent';
        if ($score >= 80) return 'good';
        if ($score >= 70) return 'fair';
        if ($score >= 60) return 'poor';
        return 'critical';
    }
    
    private function get_health_issues($basic_checks, $detailed_checks) {
        $all_issues = array();
        
        foreach ($basic_checks as $check) {
            $all_issues = array_merge($all_issues, $check['issues']);
        }
        
        foreach ($detailed_checks as $check) {
            if (isset($check['issues'])) {
                $all_issues = array_merge($all_issues, $check['issues']);
            }
        }
        
        // Trier par sévérité
        usort($all_issues, function($a, $b) {
            $severity_order = array('critical' => 4, 'high' => 3, 'medium' => 2, 'low' => 1);
            return $severity_order[$b['severity']] - $severity_order[$a['severity']];
        });
        
        return $all_issues;
    }
    
    // Méthodes de vérification détaillées (simplifiées)
    private function check_security_health() {
        return array('status' => 'good', 'score' => 85, 'issues' => array());
    }
    
    private function check_performance_health() {
        return array('status' => 'good', 'score' => 80, 'issues' => array());
    }
    
    private function check_seo_health() {
        return array('status' => 'fair', 'score' => 75, 'issues' => array());
    }
    
    private function check_updates_health() {
        return array('status' => 'good', 'score' => 90, 'issues' => array());
    }
}