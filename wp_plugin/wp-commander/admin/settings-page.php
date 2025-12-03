<?php

if (!defined('ABSPATH')) {
    exit; // Exit if accessed directly.
}

// Récupérer les informations nécessaires
$api_key = get_option('wp_commander_api_key');
$site_url = site_url('/');

?>

<div class="wrap">
    <h1><?php echo esc_html(get_admin_page_title()); ?></h1>

    <div class="notice notice-info inline">
        <p><?php _e('Use these details to connect your WP Commander mobile app.', 'wp-commander'); ?></p>
    </div>

    <div id="poststuff">
        <div id="post-body" class="metabox-holder columns-1">
            <div id="post-body-content">
                <div class="postbox">
                    <h2 class="hndle"><span><?php _e('Connection Credentials', 'wp-commander'); ?></span></h2>
                    <div class="inside">
                        <form>
                            <table class="form-table">
                                <tbody>
                                    <tr>
                                        <th scope="row">
                                            <label for="wp_commander_site_url"><?php _e('Site URL', 'wp-commander'); ?></label>
                                        </th>
                                        <td>
                                            <input name="wp_commander_site_url" type="text" id="wp_commander_site_url" value="<?php echo esc_url($site_url); ?>" class="large-text" readonly="readonly" />
                                            <p class="description"><?php _e('Enter this URL in the mobile app.', 'wp-commander'); ?></p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">
                                            <label for="wp_commander_api_key"><?php _e('API Key', 'wp-commander'); ?></label>
                                        </th>
                                        <td>
                                            <input name="wp_commander_api_key" type="text" id="wp_commander_api_key" value="<?php echo esc_attr($api_key); ?>" class="large-text" readonly="readonly" />
                                            <p class="description"><?php _e('This is your secret key. Keep it safe! Copy and paste it into the mobile app.', 'wp-commander'); ?></p>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
