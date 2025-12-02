<?php
/**
 * Plugin Name: WP Commander Mobile Connector
 * Plugin URI: https://yourwebsite.com/wp-commander
 * Description: Connect your WordPress site to WP Commander Mobile App - Manage your site from mobile with real-time stats, health monitoring, and comment management.
 * Version: 1.0.3
 * Author: Your Name
 * License: GPL v2 or later
 * License URI: https://www.gnu.org/licenses/gpl-2.0.html
 * Text Domain: wp-commander
 * Requires at least: 6.0
 * Requires PHP: 7.4
 */

// Sécurité : empêcher l'accès direct
defined('ABSPATH') || exit;

define('WP_COMMANDER_VERSION', '1.0.3');
define('WP_COMMANDER_PLUGIN_URL', plugin_dir_url(__FILE__));
define('WP_COMMANDER_PLUGIN_PATH', plugin_dir_path(__FILE__));
define('WP_COMMANDER_PLUGIN_FILE', __FILE__);

require_once WP_COMMANDER_PLUGIN_PATH . 'includes/utils/class-logger.php';
require_once WP_COMMANDER_PLUGIN_PATH . 'includes/security/class-api-authentication.php';
require_once WP_COMMANDER_PLUGIN_PATH . 'includes/api/class-actions-controller.php';

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
        // DIAGNOSTIC AGRESSIF : Ceci doit TOUJOURS apparaître si le plugin est actif.
        add_action('admin_notices', function() {
            echo '<div class="notice notice-info"><p><strong>WP Commander Diagnostic (v1.0.3):</strong> Le cœur du plugin est en cours d'exécution.</p></div>';
        });

        register_activation_hook(__FILE__, array($this, 'activate'));
        register_deactivation_hook(__FILE__, array($this, 'deactivate'));
        
        add_action('init', array($this, 'init'));
        add_action('rest_api_init', array($this, 'register_rest_routes'));
        add_action('admin_menu', array($this, 'add_admin_menu'));
        add_action('admin_init', array($this, 'admin_init'));

        new WP_Commander_API_Authentication();
    }
    
    public function activate() {
        add_option('wp_commander_api_key', $this->generate_api_key());
    }
    
    // ... (le reste de la classe)

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
        include WP_COMMANDER_PLUGIN_PATH . 'admin/settings-page.php';
    }

    // ... (le reste de la classe et du fichier)
}

function wp_commander() {
    return WPCommander::get_instance();
}
wp_commander();
