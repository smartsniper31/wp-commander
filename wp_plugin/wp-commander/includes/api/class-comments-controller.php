<?php

class WP_Commander_Comments_Controller extends WP_Commander_Base_Controller {
    
    protected $rest_base = 'comments';
    
    public function register_routes() {
        register_rest_route($this->namespace, '/' . $this->rest_base, array(
            array(
                'methods' => WP_REST_Server::READABLE,
                'callback' => array($this, 'get_comments'),
                'permission_callback' => array($this, 'check_permission'),
                'args' => $this->get_collection_params(),
            ),
        ));
        
        register_rest_route($this->namespace, '/' . $this->rest_base . '/(?P<id>[\d]+)/approve', array(
            array(
                'methods' => WP_REST_Server::CREATABLE,
                'callback' => array($this, 'approve_comment'),
                'permission_callback' => array($this, 'check_permission'),
            ),
        ));
        
        register_rest_route($this->namespace, '/' . $this->rest_base . '/(?P<id>[\d]+)/delete', array(
            array(
                'methods' => WP_REST_Server::DELETABLE,
                'callback' => array($this, 'delete_comment'),
                'permission_callback' => array($this, 'check_permission'),
            ),
        ));
        
        register_rest_route($this->namespace, '/' . $this->rest_base . '/(?P<id>[\d]+)/spam', array(
            array(
                'methods' => WP_REST_Server::CREATABLE,
                'callback' => array($this, 'spam_comment'),
                'permission_callback' => array($this, 'check_permission'),
            ),
        ));
    }
    
    public function get_comments($request) {
        try {
            $params = $request->get_params();
            
            $args = array(
                'status' => $params['status'] ?? 'all',
                'number' => $params['per_page'] ?? 20,
                'offset' => (($params['page'] ?? 1) - 1) * ($params['per_page'] ?? 20),
                'orderby' => 'comment_date',
                'order' => 'DESC',
            );
            
            // Filtrer par statut
            if ($args['status'] !== 'all') {
                $args['status'] = $args['status'];
            }
            
            $comments = get_comments($args);
            $formatted_comments = array();
            
            foreach ($comments as $comment) {
                $formatted_comments[] = $this->format_comment($comment);
            }
            
            // Statistiques des commentaires
            $comment_counts = wp_count_comments();
            
            $response_data = array(
                'comments' => $formatted_comments,
                'pagination' => array(
                    'page' => (int) ($params['page'] ?? 1),
                    'per_page' => (int) ($params['per_page'] ?? 20),
                    'total' => (int) $comment_counts->total_comments,
                    'total_pages' => ceil($comment_counts->total_comments / ($params['per_page'] ?? 20)),
                ),
                'counts' => array(
                    'all' => (int) $comment_counts->total_comments,
                    'approved' => (int) $comment_counts->approved,
                    'pending' => (int) $comment_counts->moderated,
                    'spam' => (int) $comment_counts->spam,
                    'trash' => (int) $comment_counts->trash,
                ),
            );
            
            return $this->success_response($response_data, 'Comments retrieved successfully');
            
        } catch (Exception $e) {
            return $this->error_response('Failed to get comments: ' . $e->getMessage());
        }
    }
    
    public function approve_comment($request) {
        try {
            $comment_id = $request['id'];
            
            if (!wp_set_comment_status($comment_id, 'approve')) {
                return $this->error_response('Failed to approve comment');
            }
            
            $this->clear_cache('comments');
            
            return $this->success_response(
                array('comment_id' => $comment_id),
                'Comment approved successfully'
            );
            
        } catch (Exception $e) {
            return $this->error_response('Failed to approve comment: ' . $e->getMessage());
        }
    }
    
    public function delete_comment($request) {
        try {
            $comment_id = $request['id'];
            
            if (!wp_delete_comment($comment_id, true)) { // true = force delete
                return $this->error_response('Failed to delete comment');
            }
            
            $this->clear_cache('comments');
            
            return $this->success_response(
                array('comment_id' => $comment_id),
                'Comment deleted successfully'
            );
            
        } catch (Exception $e) {
            return $this->error_response('Failed to delete comment: ' . $e->getMessage());
        }
    }
    
    public function spam_comment($request) {
        try {
            $comment_id = $request['id'];
            
            if (!wp_set_comment_status($comment_id, 'spam')) {
                return $this->error_response('Failed to mark comment as spam');
            }
            
            $this->clear_cache('comments');
            
            return $this->success_response(
                array('comment_id' => $comment_id),
                'Comment marked as spam successfully'
            );
            
        } catch (Exception $e) {
            return $this->error_response('Failed to mark comment as spam: ' . $e->getMessage());
        }
    }
    
    private function format_comment($comment) {
        $post = get_post($comment->comment_post_ID);
        
        return array(
            'id' => (int) $comment->comment_ID,
            'author_name' => $comment->comment_author,
            'author_email' => $comment->comment_author_email,
            'author_avatar' => get_avatar_url($comment->comment_author_email, array('size' => 64)),
            'author_ip' => $comment->comment_author_IP,
            'author_url' => $comment->comment_author_url,
            'content' => $comment->comment_content,
            'date' => $comment->comment_date,
            'status' => $comment->comment_approved,
            'post_id' => (int) $comment->comment_post_ID,
            'post_title' => $post ? $post->post_title : 'Unknown Post',
        );
    }
    
    public function get_collection_params() {
        return array(
            'page' => array(
                'description' => 'Current page of the collection',
                'type' => 'integer',
                'default' => 1,
                'sanitize_callback' => 'absint',
            ),
            'per_page' => array(
                'description' => 'Maximum number of items to be returned in result set',
                'type' => 'integer',
                'default' => 20,
                'sanitize_callback' => 'absint',
            ),
            'status' => array(
                'description' => 'Limit result set to comments assigned a specific status',
                'type' => 'string',
                'default' => 'all',
                'enum' => array('all', 'hold', 'approve', 'spam', 'trash'),
            ),
        );
    }
}