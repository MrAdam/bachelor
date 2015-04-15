<?php
	
	if (!isset($_POST['person']))
		die('Validation error!');
	
	if (!isset($_POST['navigating']))
		die('Validation error!');
	
	$mysqli = new mysqli('127.0.0.1','root','toor','bachelor');
	if ($mysqli->connect_error)
		die('Error : ('. $mysqli->connect_errno .') '. $mysqli->connect_error);
	
	$mysqli->close();
	
	var_dump($_POST);
	
?>