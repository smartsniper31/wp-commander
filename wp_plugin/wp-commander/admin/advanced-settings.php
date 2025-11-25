<?php
if (!defined('ABSPATH')) {
    exit;
}

$logger = new WP_Commander_Logger();
$logs = $logger->get_logs(array('limit' => 20));
?>

<div class="wrap">
    <h1>WP Commander Advanced Settings</h1>
    
    <div class="wp-commander-admin">
        <!-- Navigation par onglets -->
        <nav class="nav-tab-wrapper">
            <a href="#logs" class="nav-tab nav-tab-active">Activity Logs</a>
            <a href="#security" class="nav-tab">Security</a>
            <a href="#tools" class="nav-tab">Tools</a>
        </nav>
        
        <!-- Onglet Logs -->
        <div id="logs" class="tab-content active">
            <div class="card">
                <h2>Recent Activity</h2>
                
                <div class="log-controls">
                    <button type="button" class="button" onclick="refreshLogs()">Refresh</button>
                    <button type="button" class="button" onclick="clearOldLogs()">Clear Old Logs</button>
                    <button type="button" class="button button-primary" onclick="exportLogs()">Export Logs</button>
                </div>
                
                <div class="log-table-container">
                    <table class="widefat fixed" cellspacing="0">
                        <thead>
                            <tr>
                                <th>Time</th>
                                <th>Level</th>
                                <th>Message</th>
                                <th>IP Address</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php if (empty($logs)):
 ?>
                                <tr>
                                    <td colspan="4" class="no-logs">No activity logs found.</td>
                                </tr>
                            <?php else: ?>
                                <?php foreach ($logs as $log):
 ?>
                                    <tr class="log-level-<?php echo esc_attr($log->level); ?>">
                                        <td><?php echo esc_html($log->timestamp); ?></td>
                                        <td>
                                            <span class="log-badge log-<?php echo esc_attr($log->level); ?>">
                                                <?php echo esc_html(ucfirst($log->level)); ?>
                                            </span>
                                        </td>
                                        <td><?php echo esc_html($log->message); ?></td>
                                        <td><?php echo esc_html($log->user_ip); ?></td>
                                    </tr>
                                <?php endforeach; ?>
                            <?php endif; ?>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        
        <!-- Onglet Sécurité -->
        <div id="security" class="tab-content">
            <div class="card">
                <h2>Security Settings</h2>
                
                <table class="form-table">
                    <tr>
                        <th>Failed Login Attempts</th>
                        <td>
                            <?php
                            $failed_attempts = get_option('wp_commander_failed_attempts', array());
                            echo count($failed_attempts) . ' recent failed attempts';
                            ?>
                            <button type="button" class="button" onclick="clearFailedAttempts()">Clear</button>
                        </td>
                    </tr>
                    <tr>
                        <th>API Key</th>
                        <td>
                            <input type="text" class="regular-text" value="<?php echo esc_attr(get_option('wp_commander_api_key')); ?>" readonly>
                            <button type="button" class="button" onclick="regenerateApiKey()">Regenerate</button>
                        </td>
                    </tr>
                    <tr>
                        <th>Rate Limiting</th>
                        <td>
                            <label>
                                <input type="checkbox" name="rate_limiting" checked disabled>
                                Enabled (100 requests per minute)
                            </label>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        
        <!-- Onglet Outils -->
        <div id="tools" class="tab-content">
            <div class="card">
                <h2>Quick Actions</h2>
                
                <div class="quick-actions">
                    <button type="button" class="button button-large" onclick="clearAllCache()">
                        🗑️ Clear All Cache
                    </button>
                    <button type="button" class="button button-large" onclick="optimizeDatabase()">
                        ⚡ Optimize Database
                    </button>
                    <button type="button" class="button button-large" onclick="runHealthCheck()">
                        🏥 Run Health Check
                    </button>
                </div>
                
                <div id="action-results" class="action-results"></div>
            </div>
        </div>
    </div>
</div>

<style>
.wp-commander-admin {
    margin-top: 20px;
}

.tab-content {
    display: none;
}

.tab-content.active {
    display: block;
}

.log-table-container {
    max-height: 400px;
    overflow-y: auto;
    margin-top: 15px;
}

.log-badge {
    padding: 2px 8px;
    border-radius: 3px;
    font-size: 11px;
    font-weight: bold;
    text-transform: uppercase;
}

.log-info {
    background: #d1ecf1;
    color: #0c5460;
}

.log-warning {
    background: #fff3cd;
    color: #856404;
}

.log-error {
    background: #f8d7da;
    color: #721c24;
}

.log-debug {
    background: #e2e3e5;
    color: #383d41;
}

.quick-actions {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 15px;
    margin: 20px 0;
}

.action-results {
    margin-top: 15px;
    padding: 10px;
    border-radius: 4px;
    display: none;
}

.action-results.success {
    background: #d4edda;
    color: #155724;
    display: block;
}

.action-results.error {
    background: #f8d7da;
    color: #721c24;
    display: block;
}
</style>

<script>
// Navigation par onglets
document.querySelectorAll('.nav-tab').forEach(tab => {
    tab.addEventListener('click', (e) => {
        e.preventDefault();
        
        // Désactiver tous les onglets
        document.querySelectorAll('.nav-tab').forEach(t => t.classList.remove('nav-tab-active'));
        document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
        
        // Activer l'onglet courant
        tab.classList.add('nav-tab-active');
        const target = document.querySelector(tab.getAttribute('href'));
        if (target) {
            target.classList.add('active');
        }
    });
});

// Fonctions pour les actions
async function clearAllCache() {
    const results = document.getElementById('action-results');
    results.className = 'action-results';
    results.textContent = 'Clearing cache...';
    
    try {
        const response = await fetch('<?php echo rest_url('wp-commander/v1/quick-actions/clear-cache'); ?>', {
            method: 'POST',
            headers: {
                'X-WPC-API-KEY': '<?php echo esc_js(get_option('wp_commander_api_key')); ?>',
                'Content-Type': 'application/json',
            },
        });
        
        const data = await response.json();
        
        if (data.success) {
            results.className = 'action-results success';
            results.innerHTML = '<strong>Success!</strong><br>' + 
                data.data.actions.join('<br>');
        } else {
            throw new Error(data.message);
        }
    } catch (error) {
        results.className = 'action-results error';
        results.textContent = 'Error: ' + error.message;
    }
}

async function optimizeDatabase() {
    // Implémentation similaire à clearAllCache
}

async function runHealthCheck() {
    // Implémentation similaire à clearAllCache
}

function refreshLogs() {
    location.reload();
}

async function clearOldLogs() {
    if (confirm('Are you sure you want to clear logs older than 30 days?')) {
        // Implémenter la suppression des vieux logs
        location.reload();
    }
}

function exportLogs() {
    // Implémenter l'export des logs
    alert('Export feature coming soon!');
}

function clearFailedAttempts() {
    if (confirm('Clear all failed attempt records?')) {
        // Implémenter la suppression des tentatives échouées
        location.reload();
    }
}

function regenerateApiKey() {
    if (confirm('Regenerating API key will disconnect all mobile apps. Continue?')) {
        // Implémenter la régénération de la clé API
        location.reload();
    }
}
</script>