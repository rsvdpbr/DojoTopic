<?php

// @ sandbox
ini_set('display_errors', '1');
/* $_POST['method'] = 'getUserData'; */
/* $_POST['value'] = 'w-leads@4MACTY'; */
/* ユーザ登録する場合 */
/* $_POST['method'] = 'addUser'; */
/* $_POST['value'] = '{"user":"w-leads","password":"4MACTY","name":"西川遼"}'; */

// @ load module
require_once './DatabaseAccess.class.php';
require_once './User.class.php';
require_once './json/JSON.php';

// @ create objects
$UClass = new User();

// @ call method
$method = array($UClass, $_POST['method']);
$value = isset($_POST['value']) && !empty($_POST['value']) ? $_POST['value'] : null;
if(is_callable($method)){
	$method = $_POST['method'];
	if($value){
		$data = $UClass->{$method}($value);
	}else{
		$data = $UClass->{$method}();
	}
	header('Content-type: text/javascript; charset=utf8');
	$json = new Services_JSON;
	$data = $json->encode($data);
	echo $data;
	exit;
}


?>