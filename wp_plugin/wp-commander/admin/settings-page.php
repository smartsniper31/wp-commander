<?php

if (!defined('ABSPATH')) {
    exit; // Exit if accessed directly.
}

$api_key = get_option('wp_commander_api_key');
$site_url = site_url('/');

?>

<div class="wrap">
    <h1><?php echo esc_html(get_admin_page_title()); ?></h1>

    <div id="poststuff">
        <div id="post-body" class="metabox-holder columns-2">
            <!-- Colonne principale -->
            <div id="post-body-content">
                <div class="meta-box-sortables ui-sortable">
                    <div class="postbox">
                        <h2 class="hndle"><span><?php _e('Connection Details', 'wp-commander'); ?></span></h2>
                        <div class="inside">
                            <p><?php _e('Use these details to connect your WP Commander mobile app.', 'wp-commander'); ?></p>
                            
                            <table class="form-table">
                                <tbody>
                                    <tr>
                                        <th scope="row">
                                            <label for="wp_commander_site_url"><?php _e('Site URL', 'wp-commander'); ?></label>
                                        </th>
                                        <td>
                                            <input type="text" id="wp_commander_site_url" class="large-text" readonly value="<?php echo esc_url($site_url); ?>">
                                            <p class="description"><?php _e('Enter this URL in your mobile app.', 'wp-commander'); ?></p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th scope="row">
                                            <label for="wp_commander_api_key"><?php _e('API Key', 'wp-commander'); ?></label>
                                        </th>
                                        <td>
                                            <input type="text" id="wp_commander_api_key" class="large-text" readonly value="<?php echo esc_attr($api_key); ?>">
                                            <p class="description"><?php _e('This is your secret key. Keep it safe!', 'wp-commander'); ?></p>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Colonne latérale -->
            <div id="postbox-container-1" class="postbox-container">
                <div class="meta-box-sortables">
                    <div class="postbox">
                        <h2 class="hndle"><span><?php _e('Instructions', 'wp-commander'); ?></span></h2>
                        <div class="inside">
                            <p><?php _e('1. Install the WP Commander app on your mobile device.', 'wp-commander'); ?></p>
                            <p><?php _e('2. Add a new site.', 'wp-commander'); ?></p>
                            <p><?php _e('3. Copy and paste the Site URL and API Key from this page into the app.', 'wp-commander'); ?></p>
                            <p><strong><?php _e('You are now ready to connect!', 'wp-commander'); ?></strong></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <br class="clear">
    </div>
</div>
