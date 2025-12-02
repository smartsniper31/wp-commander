<?php
/**
 * Plugin Name: WP Commander Mobile Connector
 * Plugin URI: https://yourwebsite.com/wp-commander
 * Description: Connect your WordPress site to WP Commander Mobile App - Manage your site from mobile with real-time stats, health monitoring, and comment management.
 * Version: 1.0.1
 * Author: Your Name
 * License: GPL v2 or later
 * License URI: https://www.gnu.org/licenses/gpl-2.0.html
 * Text Domain: wp-commander
 * Requires at least: 6.0
 * Requires PHP: 7.4
 */

// Sécurité : empêcher l'accès direct
defined('ABSPATH') || exit;

// Définir les constantes du plugin
define('WP_COMMANDER_VERSION', '1.0.1');
define('WP_COMMANDER_PLUGIN_URL', plugin_dir_url(__FILE__));
define('WP_COMMANDER_PLUGIN_PATH', plugin_dir_path(__FILE__));
define('WP_COMMANDER_PLUGIN_FILE', __FILE__);

// MODIFIÉ : Charger les utilitaires en premier
require_once WP_COMMANDER_PLUGIN_PATH . 'includes/utils/class-logger.php';
require_once WP_COMMANDER_PLUGIN_PATH . 'includes/security/class-api-authentication.php';
require_once WP_COMMANDER_PLUGIN_PATH . 'includes/api/class-actions-controller.php';

// Classe principale du plugin
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
        // Activation et désactivation
        register_activation_hook(__FILE__, array($this, 'activate'));
        register_deactivation_hook(__FILE__, array($this, 'deactivate'));
        
        // Initialisation
        add_action('init', array($this, 'init'));
        
        // API REST
        add_action('rest_api_init', array($this, 'register_rest_routes'));
        
        // Admin
        add_action('admin_menu', array($this, 'add_admin_menu'));
        add_action('admin_init', array($this, 'admin_init'));

        // Sécurité API
        new WP_Commander_API_Authentication();
    }
    
    public function activate() {
        // Créer les options par défaut
        add_option('wp_commander_api_key', $this->generate_api_key());
        add_option('wp_commander_enabled', 'yes');
        add_option('wp_commander_logging', 'no');
        
        // Logger l'activation
        $this->log('Plugin activated');
    }
    
    public function deactivate() {
        // Nettoyer les transients
        $this->cleanup_transients();
        $this->log('Plugin deactivated');
    }
    
    public function init() {
        load_plugin_textdomain('wp-commander', false, dirname(plugin_basename(__FILE__)) . '/languages');
    }
    
    public function register_rest_routes() {
        require_once WP_COMMANDER_PLUGIN_PATH . 'includes/api/class-base-controller.php';
        require_once WP_COMMANDER_PLUGIN_PATH . 'includes/api/class-dashboard-controller.php';
        require_once WP_COMMANDER_PLUGIN_PATH . 'includes/api/class-health-controller.php';
        require_once WP_COMMANDER_PLUGIN_PATH . 'includes/api/class-comments-controller.php';
        
        $controllers = array(
            'WP_Commander_Dashboard_Controller',
            'WP_Commander_Health_Controller',
            'WP_Commander_Comments_Controller',
            'WP_Commander_Actions_Controller',
        );
        
        foreach ($controllers as $controller_class) {
            if (class_exists($controller_class)) {
                $controller = new $controller_class();
                $controller->register_routes();
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

        /* MODIFIÉ : Le code suivant contenait un bug et a été désactivé
        // Page avancée
        add_submenu_page(
            'wp-commander', // Slug de la page parente
            'WP Commander Advanced',
            'Advanced',
            'manage_options',
            'wp-commander-advanced',
            array($this, 'advanced_admin_page')
        );
        */
    }

    public function advanced_admin_page() {
        include WP_COMMANDER_PLUGIN_PATH . 'admin/advanced-settings.php';
    }
    
    public function admin_init() {
        $this->register_settings();
    }
    
    public function admin_page() {
        include WP_COMMANDER_PLUGIN_PATH . 'admin/settings-page.php';
    }
    
    private function register_settings() {
        register_setting('wp_commander_settings', 'wp_commander_api_key');
        register_setting('wp_commander_settings', 'wp_commander_enabled');
        register_setting('wp_commander_settings', 'wp_commander_logging');
        
        add_settings_section(
            'wp_commander_general',
            'General Settings',
            array($this, 'general_section_callback'),
            'wp-commander'
        );
        
        add_settings_field(
            'wp_commander_api_key',
            'API Key',
            array($this, 'api_key_field_callback'),
            'wp-commander',
            'wp_commander_general'
        );
        
        add_settings_field(
            'wp_commander_enabled',
            'Enable Mobile Access',
            array($this, 'enabled_field_callback'),
            'wp-commander',
            'wp_commander_general'
        );
    }
    
    public function general_section_callback() {
        echo '<p>Configure your WP Commander mobile app connection settings.</p>';
    }
    
    public function api_key_field_callback() {
        $api_key = get_option('wp_commander_api_key');
        echo '<input type="text" id="wp_commander_api_key" name="wp_commander_api_key" value="' . esc_attr($api_key) . '" class="regular-text" readonly>';
        echo '<p class="description">Your unique API key for mobile app connection. Keep this secure.</p>';
    }
    
    public function enabled_field_callback() {
        $enabled = get_option('wp_commander_enabled', 'yes');
        echo '<label><input type="checkbox" name="wp_commander_enabled" value="yes" ' . checked('yes', $enabled, false) . '> Enable mobile access</label>';
    }
    
    private function generate_api_key() {
        return 'wpc_' . bin2hex(random_bytes(16));
    }
    
    private function cleanup_transients() {
        global $wpdb;
        $wpdb->query("DELETE FROM {$wpdb->options} WHERE option_name LIKE '_transient_wp_commander_%'");
        $wpdb->query("DELETE FROM {$wpdb->options} WHERE option_name LIKE '_transient_timeout_wp_commander_%'");
    }
    
    private function log($message) {
        if (get_option('wp_commander_logging') === 'yes') {
            $logger = new WP_Commander_Logger();
            $logger->info($message);
        }
    }
}

// Initialiser le plugin
function wp_commander() {
    return WPCommander::get_instance();
}

// Démarrer le plugin
wp_commander();