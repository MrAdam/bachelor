<?php
	
	if (!isset($_POST['person']))
		die('Validation error!');
	
	if (!isset($_POST['navigating']))
		die('Validation error!');
	
	$mysqli = new mysqli('127.0.0.1','root','toor','bachelor');
	if ($mysqli->connect_error)
		die('Error : ('. $mysqli->connect_errno .') '. $mysqli->connect_error);
	
	$reference 	= '"'.$mysqli->real_escape_string($_POST['person']['reference']).'"';
	$age 		= '"'.$mysqli->real_escape_string($_POST['person']['age']).'"';
	$gender 	= '"'.$mysqli->real_escape_string($_POST['person']['gender']).'"';
	$videogames = '"'.$mysqli->real_escape_string($_POST['person']['videogames']).'"';
	$computers 	= '"'.$mysqli->real_escape_string($_POST['person']['computers']).'"';
	$hand 		= '"'.$mysqli->real_escape_string($_POST['person']['hand']).'"';
	$device 	= '"'.$mysqli->real_escape_string($_POST['person']['device']).'"';
	
	$insert_person = $mysqli->query("INSERT INTO person (reference, age, gender, videogames, computers, hand, device) VALUES ($reference, $age, $gender, $videogames, $computers, $hand, $device)");
	if (!$insert_person)
		die('Error : ('. $mysqli->errno .') '. $mysqli->error);
	else
		$insert_person = $mysqli->insert_id;
	
	foreach ($_POST['navigating'] as $task) {
		$person 	= $insert_person;
		$type 		= '"'.$mysqli->real_escape_string('navigating').'"';
		$distance 	= (int)$task['distance'];
		$width		= (int)$task['width'];
		$insert_task = $mysqli->query("INSERT INTO task (person, type, distance, width) VALUES ($person, $type, $distance, $width)");
		if (!insert_task)
			die('Error : ('. $mysqli->errno .') '. $mysqli->error);
	}
	
	$mysqli->close();
	
	var_dump($_POST);
	
?>