<?php

class Topic {
	
	private $DBClass = null;
	private $JSON = null;

	function __construct(){
		$this->DBClass = new DatabaseAccess();
		$this->JSON = new Services_JSON;
	}

	function getCategoryList(){
		// @ get data
		$query = "SELECT * FROM `categories` WHERE delete_flag = 0";
		$data = $this->DBClass->executeQuery($query);
		return $data;
	}
	
	function getTopicList($options = array()){
		// @ set options
		$default = array(
			'conditions' => '1',
			'order' => 'last_update DESC',
			'limit' => '20',
			'page' => '0',
		);
		if(!is_array($options)){
			$options = (array)$this->JSON->decode($options);
		}
		$options = array_merge($default, $options);
		$offset = $options['page'] * $options['limit'];
		// @ get data
		$query = "SELECT `topics`.id AS id,  `topics`.user_id AS user_id,  `topics`.title AS title,  `topics`.category_id AS category_id,  `topics`.description AS description,  `topics`.anonymous_owner AS anonymous_owner,  `topics`.anonymous_guest AS anonymous_guest, MAX(  `posts`.created ) AS last_update, COUNT(  `posts`.id ) AS count,  `topics`.created AS created,  `topics`.modified AS modified ";
		$query .= "FROM `topics` ";
		$query .= "LEFT JOIN `posts` ON `topics`.id = `posts`.topic_id ";
		$query .= "WHERE `topics`.delete_flag = 0 AND ({$options['conditions']}) ";
		$query .= "GROUP BY `topics`.id ";
		$query .= "ORDER BY {$options['order']} ";
		$query .= "LIMIT {$offset}, {$options['limit']} ";
		$data = $this->DBClass->executeQuery($query);
		return $data;
	}

	function getPost($options){
		// @ set options
		$default = array(
			'conditions' => array('1'),
			'order' => 'created DESC',
			'limit' => '20',
			'page' => '0',
		);
		$options = (array)$this->JSON->decode($options);
		$options = array_merge($default, $options);
		$options['conditions'][] = 'topic_id = '.$options['topic_id'];
		$tmp = array();
		foreach($options['conditions'] as $i){
			$tmp[] = '('.$i.')';
		}
		$options['conditions'] = implode(' AND ', $tmp);
		$offset = $options['page'] * $options['limit'];
		// @ get data
		$query = "SELECT `posts`.*, `users`.username, `users`.display_name FROM `posts` ";
		$query .= "LEFT JOIN  `users` ON  `users`.id = (`posts`.user_id * ((`posts`.anonymous_flag +1)%2)) ";
		$query .= "WHERE delete_flag = 0 AND ({$options['conditions']}) ";
		$query .= "ORDER BY {$options['order']} ";
		$query .= "LIMIT {$offset}, {$options['limit']} ";
		$data = $this->DBClass->executeQuery($query);
		return $data;
	}
	/* ここのcoffeescript側の処理から */
	function getPostCount($id){
		if(!ctype_number($id)){
			die('invalid argument');
		}
		$query = "SELECT COUNT(*) as count FROM `posts` WHERE topic_id = {$id}";
		$data = $this->DBClass->executeQuery($query);
		return $data;
	}

	function savePost($data){
		$now = date('Y-m-d H:i:s');
		$data = (array)$this->JSON->decode($data);
		$query = "INSERT INTO `posts` VALUES";
		$query .= "(NULL, {$data['topic_id']}, {$data['user_id']}, '{$data['body']}', ";
		$query .= "{$data['anonymous_flag']}, 0, '{$now}', '{$now}')";
		$result = $this->DBClass->executeQuery($query);
		return $result;
	}

	function getUser($options){
		/* // @ set options */
		/* $default = array( */
		/* 	'conditions' => array('1'), */
		/* 	'order' => 'id ASC', */
		/* 	'limit' => '20', */
		/* 	'page' => '0', */
		/* ); */
		/* $options = (array)$this->JSON->decode($options); */
		/* $options = array_merge($default, $options); */
		/* $options['conditions'][] = 'topic_id = '.$options['topic_id']; */
		/* $tmp = array(); */
		/* foreach($options['conditions'] as $i){ */
		/* 	$tmp[] = '('.$i.')'; */
		/* } */
		/* $options['conditions'] = implode(' AND ', $tmp); */
		/* $offset = $options['page'] * $options['limit']; */
		/* // @ get data */
		/* $query = "SELECT * FROM `posts` "; */
		/* $query .= "WHERE delete_flag = 0 AND ({$options['conditions']}) "; */
		/* $query .= "ORDER BY {$options['order']} "; */
		/* $query .= "LIMIT {$offset}, {$options['limit']} "; */
		/* $data = $this->DBClass->executeQuery($query); */
		/* return $data; */
	}

}

?>