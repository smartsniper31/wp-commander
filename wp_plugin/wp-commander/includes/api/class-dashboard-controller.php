<?php

class WP_Commander_Dashboard_Controller extends WP_Commander_Base_Controller {
    
    protected $rest_base = 'dashboard';
    
    public function register_routes() {
        register_rest_route($this->namespace, '/' . $this->rest_base . '-stats', array(
            array(
                'methods' => WP_REST_Server::READABLE,
                'callback' => array($this, 'get_dashboard_stats'),
                'permission_callback' => array($this, 'check_permission'),
            ),
        ));
        
        register_rest_route($this->namespace, '/site-info', array(
            array(
                'methods' => WP_REST_Server::READABLE,
                'callback' => array($this, 'get_site_info'),
                'permission_callback' => array($this, 'check_permission'),
            ),
        ));
    }
    
    public function get_dashboard_stats($request) {
        try {
            $stats = $this->get_cached_data('dashboard_stats', function() {
                return $this->calculate_dashboard_stats();
            }, 300); // Cache 5 minutes
            
            return $this->success_response($stats, 'Dashboard stats retrieved');
            
        } catch (Exception $e) {
            return $this->error_response('Failed to get dashboard stats: ' . $e->getMessage());
        }
    }
    
    public function get_site_info($request) {
        try {
            $site_info = array(
                'name' => get_bloginfo('name'),
                'description' => get_bloginfo('description'),
                'url' => get_site_url(),
                'admin_email' => get_option('admin_email'),
                'timezone' => get_option('timezone_string'),
                'language' => get_bloginfo('language'),
                'wp_version' => get_bloginfo('version'),
                'php_version' => phpversion(),
            );
            
            return $this->success_response($site_info, 'Site info retrieved');
            
        } catch (Exception $e) {
            return $this->error_response('Failed to get site info: ' . $e->getMessage());
        }
    }
    
    private function calculate_dashboard_stats() {
        global $wpdb;
        
        // Statistiques des posts
        $post_counts = wp_count_posts();
        $page_counts = wp_count_posts('page');
        
        // Statistiques des commentaires
        $comment_counts = wp_count_comments();
        
        // Nombre d'utilisateurs
        $user_count = count_users();
        
        // Derniers commentaires en attente
        $pending_comments = get_comments(array(
            'status' => 'hold',
            'number' => 5,
            'fields' => 'ids',
        ));
        
        return array(
            'total_posts' => (int) $post_counts->publish,
            'total_pages' => (int) $page_counts->publish,
            'total_comments' => (int) $comment_counts->total_comments,
            'pending_comments' => (int) $comment_counts->moderated,
            'approved_comments' => (int) $comment_counts->approved,
            'total_users' => (int) $user_count['total_users'],
            'last_updated' => current_time('c'),
            'cache_timestamp' => current_time('c'),
        );
    }
}