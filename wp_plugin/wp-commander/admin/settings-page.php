<?php
// Sécurité
if (!defined('ABSPATH')) {
    exit;
}
?>

<div class="wrap">
    <h1>WP Commander Settings</h1>
    
    <div class="card">
        <h2>Mobile App Connection</h2>
        <p>Configure the connection settings for your WP Commander mobile app.</p>
        
        <form method="post" action="options.php">
            <?php
            settings_fields('wp_commander_settings');
            do_settings_sections('wp-commander');
            submit_button();
            ?>
        </form>
    </div>
    
    <div class="card">
        <h2>Quick Start Guide</h2>
        <ol>
            <li>Install the WP Commander mobile app on your device</li>
            <li>Copy the API Key above</li>
            <li>In the mobile app, add your site URL and paste the API Key</li>
            <li>Start managing your WordPress site from your mobile device!</li>
        </ol>
    </div>
    
    <div class="card">
        <h2>API Endpoints</h2>
        <p>Your available API endpoints:</p>
        <ul>
            <li><code><?php echo rest_url('wp-commander/v1/dashboard-stats'); ?></code></li>
            <li><code><?php echo rest_url('wp-commander/v1/site-info'); ?></code></li>
            <li><code><?php echo rest_url('wp-commander/v1/health-check'); ?></code></li>
            <li><code><?php echo rest_url('wp-commander/v1/comments'); ?></code></li>
        </ul>
    </div>
</div>

<style>
.card {
    background: #fff;
    border: 1px solid #ccd0d4;
    border-radius: 4px;
    padding: 20px;
    margin: 20px 0;
}
.card h2 {
    margin-top: 0;
}
</style>