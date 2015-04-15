<?php
	
	if (!isset($_POST['person']))
		die('Validation error!');
	
	if (!isset($_POST['navigating']))
		die('Validation error!');
	
	$mysqli = new mysqli('127.0.0.1','root','toor','bachelor');
	if ($mysqli->connect_error)
		die('Error : ('. $mysqli->connect_errno .') '. $mysqli->connect_error);
	
	$reference = $_POST['person']['reference'];
	$age = $_POST['person']['age'];
	$gender = $_POST['person']['gender'];
	$videogames = $_POST['person']['videogames'];
	$computers = $_POST['person']['computers'];
	$hand = $_POST['person']['hand'];
	$device = $_POST['person']['device'];
	
	for ($i = 0; $i < 10; $i++) {
		
	}
	
	$mysqli->close();
	
	
	var_dump($_POST);
	
?>