<?php

class WP_Commander_Actions_Controller extends WP_Commander_Base_Controller {
    
    protected $rest_base = 'actions';
    
    public function register_routes() {
        register_rest_route($this->namespace, '/quick-actions/clear-cache', array(
            array(
                'methods' => WP_REST_Server::CREATABLE,
                'callback' => array($this, 'clear_cache'),
                'permission_callback' => array($this, 'check_permission'),
            ),
        ));
        
        register_rest_route($this->namespace, '/quick-actions/maintenance-mode', array(
            array(
                'methods' => WP_REST_Server::CREATABLE,
                'callback' => array($this, 'toggle_maintenance_mode'),
                'permission_callback' => array($this, 'check_permission'),
            ),
        ));
        
        register_rest_route($this->namespace, '/quick-actions/optimize-database', array(
            array(
                'methods' => WP_REST_Server::CREATABLE,
                'callback' => array($this, 'optimize_database'),
                'permission_callback' => array($this, 'check_permission'),
            ),
        ));
        
        register_rest_route($this->namespace, '/notifications', array(
            array(
                'methods' => WP_REST_Server::READABLE,
                'callback' => array($this, 'get_notifications'),
                'permission_callback' => array($this, 'check_permission'),
            ),
        ));
    }
    
    public function clear_cache($request) {
        try {
            $results = array();
            
            // Vider le cache des transients WordPress
            $this->clear_wordpress_cache();
            $results[] = 'WordPress cache cleared';
            
            // Vider le cache des plugins populaires
            if ($this->clear_w3_total_cache()) {
                $results[] = 'W3 Total Cache cleared';
            }
            
            if ($this->clear_wp_rocket_cache()) {
                $results[] = 'WP Rocket cache cleared';
            }
            
            if ($this->clear_wp_super_cache()) {
                $results[] = 'WP Super Cache cleared';
            }
            
            // Vider le cache du navigateur (CDN headers)
            $this->add_cache_headers();
            
            $this->log_action('cache_cleared');
            
            return $this->success_response(
                array('actions' => $results),
                'Cache cleared successfully'
            );
            
        } catch (Exception $e) {
            return $this->error_response('Failed to clear cache: ' . $e->getMessage());
        }
    }
    
    public function toggle_maintenance_mode($request) {
        try {
            $params = $request->get_json_params();
            $enable = $params['enable'] ?? false;
            
            $maintenance_file = ABSPATH . '.maintenance';
            
            if ($enable) {
                // Activer le mode maintenance
                $content = "<?php\n";
                $content .= "\$upgrading = " . time() . ";\n";
                $content .= "?>";
                
                if (file_put_contents($maintenance_file, $content) === false) {
                    return $this->error_response('Failed to enable maintenance mode');
                }
                
                $message = 'Maintenance mode enabled';
            } else {
                // Désactiver le mode maintenance
                if (file_exists($maintenance_file)) {
                    if (!unlink($maintenance_file)) {
                        return $this->error_response('Failed to disable maintenance mode');
                    }
                }
                
                $message = 'Maintenance mode disabled';
            }
            
            $this->log_action('maintenance_toggled', array('enabled' => $enable));
            
            return $this->success_response(
                array('enabled' => $enable),
                $message
            );
            
        } catch (Exception $e) {
            return $this->error_response('Failed to toggle maintenance mode: ' . $e->getMessage());
        }
    }
    
    public function optimize_database($request) {
        try {
            global $wpdb;
            
            $results = array();
            
            // Optimiser les tables de la base de données
            $tables = $wpdb->get_results("SHOW TABLES LIKE '" . $wpdb->prefix . "%'");
            
            foreach ($tables as $table) {
                $table_name = array_values((array)$table)[0];
                $wpdb->query("OPTIMIZE TABLE $table_name");
                $results[] = "Optimized table: $table_name";
            }
            
            // Nettoyer les révisions de posts
            $revisions_deleted = $this->cleanup_post_revisions();
            if ($revisions_deleted > 0) {
                $results[] = "Deleted $revisions_deleted post revisions";
            }
            
            // Nettoyer la corbeille
            $trash_cleaned = $this->cleanup_trash();
            if ($trash_cleaned > 0) {
                $results[] = "Cleaned $trash_cleaned items from trash";
            }
            
            // Nettoyer les transients expirés
            $this->cleanup_expired_transients();
            $results[] = 'Cleaned expired transients';
            
            $this->log_action('database_optimized');
            
            return $this->success_response(
                array('actions' => $results),
                'Database optimized successfully'
            );
            
        } catch (Exception $e) {
            return $this->error_response('Failed to optimize database: ' . $e->getMessage());
        }
    }
    
    public function get_notifications($request) {
        try {
            $notifications = $this->get_cached_data('notifications', function() {
                return $this->generate_notifications();
            }, 300); // Cache 5 minutes
            
            return $this->success_response(
                array('notifications' => $notifications),
                'Notifications retrieved successfully'
            );
            
        } catch (Exception $e) {
            return $this->error_response('Failed to get notifications: ' . $e->getMessage());
        }
    }
    
    private function clear_wordpress_cache() {
        // Vider le cache des transients
        global $wpdb;
        $wpdb->query("DELETE FROM {$wpdb->options} WHERE option_name LIKE '_transient_%'");
        $wpdb->query("DELETE FROM {$wpdb->options} WHERE option_name LIKE '_site_transient_%'");
        
        // Vider le cache objet de WordPress
        wp_cache_flush();
    }
    
    private function clear_w3_total_cache() {
        if (function_exists('w3tc_flush_all')) {
            w3tc_flush_all();
            return true;
        }
        return false;
    }
    
    private function clear_wp_rocket_cache() {
        if (function_exists('rocket_clean_domain')) {
            rocket_clean_domain();
            return true;
        }
        return false;
    }
    
    private function clear_wp_super_cache() {
        if (function_exists('wp_cache_clear_cache')) {
            wp_cache_clear_cache();
            return true;
        }
        return false;
    }
    
    private function add_cache_headers() {
        if (!headers_sent()) {
            header('Cache-Control: no-cache, no-store, must-revalidate');
            header('Pragma: no-cache');
            header('Expires: 0');
        }
    }
    
    private function cleanup_post_revisions($limit = 100) {
        global $wpdb;
        
        $revisions = $wpdb->get_results("
            SELECT ID FROM {$wpdb->posts} 
            WHERE post_type = 'revision' 
            ORDER BY post_date DESC 
            LIMIT 1000 OFFSET $limit
        ");
        
        $deleted = 0;
        foreach ($revisions as $revision) {
            if (wp_delete_post($revision->ID, true)) {
                $deleted++;
            }
        }
        
        return $deleted;
    }
    
    private function cleanup_trash() {
        global $wpdb;
        
        // Posts dans la corbeille depuis plus de 30 jours
        $old_trash = $wpdb->get_col("
            SELECT ID FROM {$wpdb->posts} 
            WHERE post_status = 'trash' 
            AND post_modified < DATE_SUB(NOW(), INTERVAL 30 DAY)
        ");
        
        $deleted = 0;
        foreach ($old_trash as $post_id) {
            if (wp_delete_post($post_id, true)) {
                $deleted++;
            }
        }
        
        return $deleted;
    }
    
    private function cleanup_expired_transients() {
        global $wpdb;
        
        $wpdb->query("
            DELETE FROM {$wpdb->options} 
            WHERE option_name LIKE '_transient_timeout_%' 
            AND option_value < " . time()
        );
        
        $wpdb->query("
            DELETE FROM {$wpdb->options} 
            WHERE option_name LIKE '_site_transient_timeout_%' 
            AND option_value < " . time()
        );
    }
    
    private function generate_notifications() {
        $notifications = array();
        
        // Vérifier les mises à jour de WordPress
        $core_update = get_site_transient('update_core');
        if (!empty($core_update->updates)) {
            foreach ($core_update->updates as $update) {
                if ($update->response === 'upgrade') {
                    $notifications[] = array(
                        'id' => 'core_update',
                        'type' => 'warning',
                        'title' => 'WordPress Update Available',
                        'message' => 'A new WordPress version is available: ' . $update->version,
                        'action' => array(
                            'label' => 'Update Now',
                            'url' => admin_url('update-core.php'),
                        ),
                        'timestamp' => current_time('c'),
                    );
                }
            }
        }
        
        // Vérifier les mises à jour de plugins
        $plugin_updates = get_site_transient('update_plugins');
        if (!empty($plugin_updates->response)) {
            $count = count($plugin_updates->response);
            $notifications[] = array(
                'id' => 'plugin_updates',
                'type' => 'info',
                'title' => 'Plugin Updates Available',
                'message' => "{$count} plugin(s) have updates available",
                'action' => array(
                    'label' => 'View Updates',
                    'url' => admin_url('plugins.php?plugin_status=upgrade'),
                ),
                'timestamp' => current_time('c'),
            );
        }
        
        // Vérifier les commentaires en attente
        $comment_counts = wp_count_comments();
        if ($comment_counts->moderated > 0) {
            $notifications[] = array(
                'id' => 'pending_comments',
                'type' => 'info',
                'title' => 'Pending Comments',
                'message' => "You have {$comment_counts->moderated} comment(s) awaiting moderation",
                'action' => array(
                    'label' => 'Moderate',
                    'url' => admin_url('edit-comments.php?comment_status=moderated'),
                ),
                'timestamp' => current_time('c'),
            );
        }
        
        // Vérifier la santé du site
        $health_check = $this->perform_quick_health_check();
        if ($health_check['score'] < 80) {
            $notifications[] = array(
                'id' => 'site_health',
                'type' => 'warning',
                'title' => 'Site Health Check',
                'message' => 'Your site health score is ' . $health_check['score'] . '/100',
                'action' => array(
                    'label' => 'View Details',
                    'url' => admin_url('site-health.php'),
                ),
                'timestamp' => current_time('c'),
            );
        }
        
        return $notifications;
    }
    
    private function perform_quick_health_check() {
        $score = 100;
        $issues = array();
        
        // Vérifications rapides
        if (!is_ssl()) {
            $score -= 20;
            $issues[] = 'SSL not enabled';
        }
        
        if (get_option('permalink_structure') === '') {
            $score -= 10;
            $issues[] = 'Plain permalinks';
        }
        
        // Vérifier la mémoire PHP
        $memory_limit = ini_get('memory_limit');
        if (wp_convert_hr_to_bytes($memory_limit) < 64 * 1024 * 1024) {
            $score -= 10;
            $issues[] = 'Low memory limit';
        }
        
        return array(
            'score' => $score,
            'issues' => $issues,
        );
    }
    
    private function log_action($action, $data = array()) {
        $log_entry = array(
            'action' => $action,
            'timestamp' => current_time('mysql'),
            'user_ip' => $this->get_client_ip(),
            'data' => $data,
        );
        
        $action_logs = get_option('wp_commander_action_logs', array());
        $action_logs[] = $log_entry;
        
        // Garder seulement les 50 dernières actions
        if (count($action_logs) > 50) {
            $action_logs = array_slice($action_logs, -50);
        }
        
        update_option('wp_commander_action_logs', $action_logs, false);
    }
    
    private function get_client_ip() {
        // Méthode utilitaire pour récupérer l'IP du client
        $ip_keys = array('HTTP_X_FORWARDED_FOR', 'HTTP_X_REAL_IP', 'HTTP_CLIENT_IP', 'REMOTE_ADDR');
        
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
}