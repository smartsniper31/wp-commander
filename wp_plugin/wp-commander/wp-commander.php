<?php
/**
 * Plugin Name: WP Commander Mobile Connector
 * Plugin URI: https://yourwebsite.com/wp-commander
 * Description: Connect your WordPress site to WP Commander Mobile App - Manage your site from mobile with real-time stats, health monitoring, and comment management.
 * Version: 1.0.6
 * Author: Your Name
 * License: GPL v2 or later
 * License URI: https://www.gnu.org/licenses/gpl-2.0.html
 * Text Domain: wp-commander
 * Requires at least: 6.0
 * Requires PHP: 7.4
 */

// Sécurité : empêcher l'accès direct
defined('ABSPATH') || exit;

// Inclusion des fichiers
require_once plugin_dir_path(__FILE__) . 'includes/api/class-base-controller.php';
require_once plugin_dir_path(__FILE__) . 'includes/utils/class-logger.php';
require_once plugin_dir_path(__FILE__) . 'includes/security/class-api-authentication.php';
require_once plugin_dir_path(__FILE__) . 'includes/api/class-actions-controller.php';
require_once plugin_dir_path(__FILE__) . 'includes/api/class-comments-controller.php';
require_once plugin_dir_path(__FILE__) . 'includes/api/class-dashboard-controller.php';
require_once plugin_dir_path(__FILE__) . 'includes/api/class-health-controller.php';


final class WPCommander {
    
    private static $instance = null;
    
    public static function get_instance() {
        if (null === self::$instance) {
            self::$instance = new self();
        }
        return self::$instance;
    }
    
    private function __construct() {
        $this->init_hooks();
    }
    
    private function init_hooks() {
        add_action('admin_notices', function() {
            echo '<div class="notice notice-success"><p><strong>WP Commander (v1.0.6):</strong> Ready to connect.</p></div>';
        });

        register_activation_hook(__FILE__, array($this, 'activate'));
        
        add_action('rest_api_init', array($this, 'register_rest_routes'));
        add_action('admin_menu', array($this, 'add_admin_menu'));

        // **CORRECTIF : Autoriser l'en-tête API personnalisé pour les requêtes CORS**
        add_filter('rest_allowed_cors_headers', array($this, 'add_custom_header_to_cors'));

        new WP_Commander_API_Authentication();
    }

    public function add_custom_header_to_cors($allowed_headers) {
        $allowed_headers[] = 'X-WPC-API-KEY';
        return $allowed_headers;
    }
    
    public function activate() {
        if (!get_option('wp_commander_api_key')) {
            add_option('wp_commander_api_key', $this->generate_api_key());
        }
    }

    public function register_rest_routes() {
        $controllers = [
            'WP_Commander_Actions_Controller',
            'WP_Commander_Comments_Controller',
            'WP_Commander_Dashboard_Controller',
            'WP_Commander_Health_Controller',
        ];

        foreach ($controllers as $controller) {
            if (class_exists($controller)) {
                $controller_instance = new $controller();
                $controller_instance->register_routes();
            }
        }
    }
    
    public function add_admin_menu() {
        add_options_page(
            'WP Commander Settings',
            'WP Commander',
            'manage_options',
            'wp-commander',
            array($this, 'admin_page')
        );
    }

    public function admin_page() {
        require_once plugin_dir_path(__FILE__) . 'admin/settings-page.php';
    }

    private function generate_api_key($length = 40) {
        return bin2hex(random_bytes($length / 2));
    }
}

function wp_commander() {
    return WPCommander::get_instance();
}
wp_commander();
