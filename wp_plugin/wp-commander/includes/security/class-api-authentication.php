<?php

if (!defined('ABSPATH')) {
    exit; // Exit if accessed directly.
}

if (!class_exists('WP_Commander_API_Authentication')) {
    class WP_Commander_API_Authentication {
        public function __construct() {
            // Ce constructeur est intentionnellement laissé vide pour le moment.
            // Il satisfait l'appel new WP_Commander_API_Authentication() dans le fichier principal.
        }
    }
}
