<?php
	
	if (!isset($_POST['person']))
		die('Error: personal data is missing!');
	
	if (!isset($_POST['navigating']))
		die('Error: tunnel data is missing!');

  if (!isset($_POST['spiraling']))
    die('Error: spiral data is missing!');
	
	if (!isset($_POST['pointing']))
		die('Error: pointing data is missing!');
	
	$mysqli = new mysqli('127.0.0.1','root','toor','bachelor');
	if ($mysqli->connect_error)
		die('Fejl: ('. $mysqli->connect_errno .') '. $mysqli->connect_error);
	
	$reference 	= '"'.$mysqli->real_escape_string($_POST['person']['reference']).'"';
	$age 		= '"'.$mysqli->real_escape_string($_POST['person']['age']).'"';
	$gender 	= '"'.$mysqli->real_escape_string($_POST['person']['gender']).'"';
	$videogames = '"'.$mysqli->real_escape_string($_POST['person']['videogames']).'"';
	$computers 	= '"'.$mysqli->real_escape_string($_POST['person']['computers']).'"';
	$hand 		= '"'.$mysqli->real_escape_string($_POST['person']['hand']).'"';
	$device 	= '"'.$mysqli->real_escape_string($_POST['person']['device']).'"';
	$browser  = '"'.$mysqli->real_escape_string($_POST['person']['browser']).'"';
	
	$insert_person = $mysqli->query("INSERT INTO person (reference, age, gender, videogames, computers, hand, device, browser) VALUES ($reference, $age, $gender, $videogames, $computers, $hand, $device, $browser)");
	if (!$insert_person)
		die('Error: ('. $mysqli->errno .') '. $mysqli->error);
	else
		$insert_person = $mysqli->insert_id;
	
	foreach ($_POST['navigating'] as $task) {
		$person 	= $insert_person;
		$type 		= '"'.$mysqli->real_escape_string('navigating').'"';
		$distance 	= (int)$task['distance'];
		$width		= (int)$task['width'];
		$time		= (float)$task['time'];
		$insert_task = $mysqli->query("INSERT INTO task (person, type, distance, width, time) VALUES ($person, $type, $distance, $width, $time)");
		if (!$insert_task)
			die('Error: ('. $mysqli->errno .') '. $mysqli->error);
		else
			$insert_task = $mysqli->insert_id;
		
		foreach ($task['points'] as $point) {
			$task			= $insert_task;
			$x				= (int)$point['x'];
			$y				= (int)$point['y'];
			$elapsedTime	= (float)$point['elapsedTime'];
			$deltaTime		= (float)$point['deltaTime'];
			$deltaDistance 	= (float)$point['deltaDistance'];
			$insert_point = $mysqli->query("INSERT INTO point (task, x, y, elapsedTime, deltaTime, deltaDistance) VALUES ($task, $x, $y, $elapsedTime, $deltaTime, $deltaDistance)");
			if (!$insert_point)
				die('Error: ('. $mysqli->errno .') '. $mysqli->error);
		}
	}

  foreach ($_POST['spiraling'] as $task) {
    $person   = $insert_person;
    $type     = '"'.$mysqli->real_escape_string('spiraling').'"';
    $distance   = (int)$task['distance'];
    $width    = (int)$task['width'];
    $time   = (float)$task['time'];
    $insert_task = $mysqli->query("INSERT INTO task (person, type, distance, width, time) VALUES ($person, $type, $distance, $width, $time)");
    if (!$insert_task)
      die('Error: ('. $mysqli->errno .') '. $mysqli->error);
    else
      $insert_task = $mysqli->insert_id;
    
    foreach ($task['points'] as $point) {
      $task     = $insert_task;
      $x        = (int)$point['x'];
      $y        = (int)$point['y'];
      $elapsedTime  = (float)$point['elapsedTime'];
      $deltaTime    = (float)$point['deltaTime'];
      $deltaDistance  = (float)$point['deltaDistance'];
      $insert_point = $mysqli->query("INSERT INTO point (task, x, y, elapsedTime, deltaTime, deltaDistance) VALUES ($task, $x, $y, $elapsedTime, $deltaTime, $deltaDistance)");
      if (!$insert_point)
        die('Error: ('. $mysqli->errno .') '. $mysqli->error);
    }
  }
	
	foreach ($_POST['pointing'] as $task) {
		$person 	= $insert_person;
		$type 		= '"'.$mysqli->real_escape_string('pointing').'"';
		$distance 	= (int)$task['distance'];
		$width		= (int)$task['width'];
		$time		= (float)$task['time'];
		$insert_task = $mysqli->query("INSERT INTO task (person, type, distance, width, time) VALUES ($person, $type, $distance, $width, $time)");
		if (!$insert_task)
			die('Error: ('. $mysqli->errno .') '. $mysqli->error);
		else
			$insert_task = $mysqli->insert_id;
		
		foreach ($task['points'] as $point) {
			$task			= $insert_task;
			$x				= (int)$point['x'];
			$y				= (int)$point['y'];
			$elapsedTime	= (float)$point['elapsedTime'];
			$deltaTime		= (float)$point['deltaTime'];
			$deltaDistance 	= (float)$point['deltaDistance'];
			$insert_point = $mysqli->query("INSERT INTO point (task, x, y, elapsedTime, deltaTime, deltaDistance) VALUES ($task, $x, $y, $elapsedTime, $deltaTime, $deltaDistance)");
			if (!$insert_point)
				die('Error: ('. $mysqli->errno .') '. $mysqli->error);
		}
	}
	
	$mysqli->close();
	
	die('Thank you for your participation, your data have been saved successfully.');
	
?>
