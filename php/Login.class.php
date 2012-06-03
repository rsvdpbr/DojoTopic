<?php

class Login {
	
	private $DBClass = null;
	private $JSON = null;

	function __construct(){
		$this->DBClass = new DatabaseAccess();
		$this->JSON = new Services_JSON;
	}

	function getUserData($data){
		// @ make query
		$data = $this->JSON->decode($data);
		$username = $data->username;
		$passwd = md5($data->passwd);
		$query = "SELECT id, username, display_name, created, modified FROM `users` ";
		$query .= "WHERE username = '{$username}' AND password = '{$passwd}' ";
		$query .= "LIMIT 1";
		// @ get data
		$data = $this->DBClass->executeQuery($query);
		if($data){
			$data = $data[0];
		}else{
			$data = false;
		}
		return $data;
	}

	function addUser($data){
		// @ make data
		$data = $this->JSON->decode($data);
		$username = $data->username;
		$passwd = md5($data->passwd);
		$display_name = $data->display_name;
		$now = date('Y-m-d H:i:s');
		// @ validation
		$query = "SELECT count(*) AS count FROM `users` WHERE username = '{$username}'";
		$count = $this->DBClass->executeQuery($query);
		$count = $count[0]['count'];
		if($count > 0){
			return 'double-error';
		}
		// @ save data
		$query = "INSERT INTO `users` ";
		$query .= "VALUES(NULL,'{$username}','{$passwd}','{$display_name}','{$now}','{$now}')";
		$this->DBClass->executeQuery($query);
		return 'success';
	}
}

?>