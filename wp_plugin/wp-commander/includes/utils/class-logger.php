<?php

class WP_Commander_Logger {
    
    private $log_table;
    
    public function __construct() {
        global $wpdb;
        $this->log_table = $wpdb->prefix . 'wp_commander_logs';
        
        $this->create_log_table();
    }
    
    private function create_log_table() {
        global $wpdb;
        
        $charset_collate = $wpdb->get_charset_collate();
        
        $sql = "CREATE TABLE IF NOT EXISTS {$this->log_table} (
            id bigint(20) NOT NULL AUTO_INCREMENT,
            level varchar(20) NOT NULL DEFAULT 'info',
            message text NOT NULL,
            context longtext,
            timestamp datetime NOT NULL,
            user_ip varchar(45),
            user_agent text,
            PRIMARY KEY (id),
            KEY level (level),
            KEY timestamp (timestamp)
        ) $charset_collate;";
        
        require_once(ABSPATH . 'wp-admin/includes/upgrade.php');
        dbDelta($sql);
    }
    
    public function log($level, $message, $context = array()) {
        global $wpdb;
        
        $data = array(
            'level' => $level,
            'message' => $message,
            'context' => maybe_serialize($context),
            'timestamp' => current_time('mysql'),
            'user_ip' => $this->get_client_ip(),
            'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? '',
        );
        
        $wpdb->insert($this->log_table, $data);
        
        // Log également dans les logs PHP si le debug est activé
        if (WP_DEBUG && WP_DEBUG_LOG) {
            error_log("WP Commander [{$level}]: {$message} " . json_encode($context));
        }
    }
    
    public function info($message, $context = array()) {
        $this->log('info', $message, $context);
    }
    
    public function warning($message, $context = array()) {
        $this->log('warning', $message, $context);
    }
    
    public function error($message, $context = array()) {
        $this->log('error', $message, $context);
    }
    
    public function debug($message, $context = array()) {
        if (WP_DEBUG) {
            $this->log('debug', $message, $context);
        }
    }
    
    public function get_logs($args = array()) {
        global $wpdb;
        
        $defaults = array(
            'level' => '',
            'limit' => 50,
            'offset' => 0,
            'orderby' => 'timestamp',
            'order' => 'DESC',
        );
        
        $args = wp_parse_args($args, $defaults);
        
        $where = array();
        $prepare_args = array();
        
        if (!empty($args['level'])) {
            $where[] = 'level = %s';
            $prepare_args[] = $args['level'];
        }
        
        $where_sql = '';
        if (!empty($where)) {
            $where_sql = 'WHERE ' . implode(' AND ', $where);
        }
        
        $order_sql = "ORDER BY {$args['orderby']} {$args['order']}";
        $limit_sql = $wpdb->prepare("LIMIT %d OFFSET %d", $args['limit'], $args['offset']);
        
        $sql = "SELECT * FROM {$this->log_table} {$where_sql} {$order_sql} {$limit_sql}";
        
        if (!empty($prepare_args)) {
            $sql = $wpdb->prepare($sql, $prepare_args);
        }
        
        return $wpdb->get_results($sql);
    }
    
    public function cleanup_old_logs($days = 30) {
        global $wpdb;
        
        $cutoff_date = date('Y-m-d H:i:s', strtotime("-{$days} days"));
        
        return $wpdb->query(
            $wpdb->prepare(
                "DELETE FROM {$this->log_table} WHERE timestamp < %s",
                $cutoff_date
            )
        );
    }
    
    private function get_client_ip() {
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