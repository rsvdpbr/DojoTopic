<?php
	ini_set('display_errors', '1');
	if(!isset($_GET["theme"])){ $_GET["theme"] = 0; }
	$style_array = array("claro", "soria", "nihilo", "tundra");
	$style = $style_array[$_GET["theme"]];
	/* require_once 'php/init.php'; */
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta http-equiv="Content-Script-Type" content="text/javascript" />
	<meta http-equiv="Content-Style-Type" content="text/css" />
	<title>てすと</title>
	<link type="text/css" rel="stylesheet" href="js/dojo172/dojo/resources/dojo.css" />
	<link type="text/css" rel="stylesheet" href="css/general.css" />
	<link type="text/css" rel="stylesheet" href="js/dojo172/dijit/themes/<?php echo $style; ?>/<?php echo $style; ?>.css" />
	<style>
	<!--
		html,body {
			width: 100%;
			height: 100%;
			padding: 0;
			margin: 0;
			overflow: hidden;
			font-size: 85%;
			font-family:'lucida grande',verdana,helvetica,arial,sans-serif;
		}
	-->
	</style>

</head>
<body class="<?php echo $style; ?>">
</body>
	<script type="text/javascript" src="js/dojo172/dojo/dojo.js" djConfig="parseOnLoad: true"></script>
	<script type="text/javascript" src="js/jquery-1.7.2.min.js"></script>
	<script type="text/javascript">
	<!--
		dojo.require("dojo.parser");
		dojo.registerModulePath("app", "../app");
		dojo.require("app.App");
		var APP;
		/* dojo.require("bt.Hash"); */
		/* var HASH; */
		$(document).ready(function(){
			var year = new Date().getYear();
			year = (year < 2000) ? year+1900 : year;
			/* HASH = new bt.Hash; */
			APP = new app.App(year);
		});
	// -->
	</script>
</html>
