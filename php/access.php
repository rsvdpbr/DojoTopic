<?php

// @ sandbox
/* ini_set('display_errors', '1'); */
/* $_POST['class'] = 'topic'; */
/* $_POST['method'] = 'getTopicList'; */
/* ini_set('display_errors', '1'); */
/* $_POST['class'] = 'topic'; */
/* $_POST['method'] = 'getCategoryList'; */

// @ load module
require_once './DatabaseAccess.class.php';
require_once './json/JSON.php';
switch($_POST['class']){
	case 'topic':
		require_once './Topic.class.php';
		$main = new Topic();
		break;
	default:
		exit;
}


// @ call method
$method = $_POST['method'];
$value = isset($_POST['value']) && !empty($_POST['value']) ? $_POST['value'] : null;
if(is_callable(array($main, $method)) && $main->isAvailable($method)){
	if($value){
		$data = $main->{$method}($value);
	}else{
		$data = $main->{$method}();
	}
	header('Content-type: text/javascript; charset=utf8');
	$json = new Services_JSON;
	$data = $json->encode($data);
	echo $data;
}else{
	echo 'the method "'.$method.'" is not found or available';
}
exit;


?>