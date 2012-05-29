<?php

// @ sandbox
/* ini_set('display_errors', '1'); */
/* $_POST['method'] = 'checkUpdateAll'; */

// @ load module
require_once './DatabaseAccess.class.php';
require_once './FindData.class.php';
require_once './json/JSON.php';

// @ create objects
$FDClass = new FindData();

// @ call method
$method = array($FDClass, $_POST['method']);
$value = isset($_POST['value']) && !empty($_POST['value']) ? $_POST['value'] : null;
if(is_callable($method)){
	$method = $_POST['method'];
	if($value){
		$data = $FDClass->{$method}($value);
	}else{
		$data = $FDClass->{$method}();
	}
	header('Content-type: text/javascript; charset=utf8');
	$json = new Services_JSON;
	$data = $json->encode($data);
	echo $data;
	exit;
}


?>