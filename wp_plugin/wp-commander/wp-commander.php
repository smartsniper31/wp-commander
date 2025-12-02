<?php
/**
 * Plugin Name: WP Commander Mobile Connector
 * Plugin URI: https://yourwebsite.com/wp-commander
 * Description: Connect your WordPress site to WP Commander Mobile App - Manage your site from mobile with real-time stats, health monitoring, and comment management.
 * Version: 1.0.2
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
define('WP_COMMANDER_VERSION', '1.0.2');
// ... (le reste des constantes)

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
        add_action('admin_menu', array($this, 'add_admin_menu'));
        // ... (autres hooks)
    }

    // ... (autres méthodes du plugin)

    public function add_admin_menu() {
        $hook_suffix = add_options_page(
            'WP Commander Settings',
            'WP Commander',
            'manage_options',
            'wp-commander',
            array($this, 'admin_page')
        );

        // MODIFIÉ : Ajout d'un diagnostic
        if ($hook_suffix === false) {
            add_action('admin_notices', function() {
                echo '<div class="notice notice-error"><p><strong>WP Commander Plugin Error:</strong> La création de la page de réglages a échoué. Le hook add_options_page() a retourné `false`. Veuillez contacter le support.</p></div>';
            });
        }
    }
    
    public function admin_page() {
        include WP_COMMANDER_PLUGIN_PATH . 'admin/settings-page.php';
    }

    // ... (le reste de la classe)
}

function wp_commander() {
    return WPCommander::get_instance();
}

wp_commander();
