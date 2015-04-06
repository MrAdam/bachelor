paper.install(window);

// Original values from the article: Two Large Open-Access Datasets for Fitts’ Law of  Human Motion and a Succinct Derivation of the Square-Root Variant
var A = [67, 184, 280, 230, 144, 249, 255, 96, 225, 263, 259, 229, 215, 198, 301, 194, 260, 296, 180, 278, 283, 40, 233, 191, 179];
var W = [20, 38, 14, 29, 55, 29, 14, 50, 19, 12, 25, 20, 31, 83, 16, 66, 12, 14, 44, 11, 37, 32, 10, 50, 18];

var pathTool, path;
var circleCenter, circleTarget;
var colorInactive = 'blue';
var colorActive = 'green';
var textRemaining = 'Targets remaining: ';
var running = false;
var finished = false;

beep = function() {
	var sound = new Audio('sound/beep.wav');
	sound.play();
}

createTarget = function(distance, width) {
	var angle = Math.floor(Math.random()*361);
	var x = (distance * Math.cos(angle * Math.PI/180)) + view.center.x;
	var y = (distance * Math.sin(angle * Math.PI/180)) + view.center.y;
	return new Path.Circle(new Point(x,y), width / 2);
}

window.onload = function() {
	paper.setup('canvas');
	
	// Create help text
	var helpText = new PointText({
		point: new Point(view.center.x, 30),
		justification: 'center',
		content: 'When a green circle appears, click on it as fast as possible',
		fillColor: 'red',
		fontWeight: 'bold',
		fontSize: 15
	});
	
	// Create remaining targets text
	var remainingText = new PointText({
		point: new Point(view.center.x, (view.center.y * 2) - 30),
		justification: 'center',
		content: textRemaining + A.length,
		fillColor: '#ccc',
		fontWeight: 'bold',
		fontSize: 15
	});

	// Center circle
	circleCenter = new Path.Circle(view.center, 20);
	circleCenter.fillColor = colorActive;

	/*
	 * Setup path tool
	 */
	pathTool = new Tool();
	
	pathTool.onMouseMove = function(event) {
		if (running) {
			path.add(event.point);
		}
	}
	
	pathTool.onMouseDown = function(event) {
		// If center circle is clicked, and a new target is needed ->
		if (circleCenter.contains(event.point) && !running && !finished) {
			// Beep to notify the testee of the action
			beep();
			// Fetch the next A (distance) and W (width)
			var distance = A.shift();
			var width = W.shift();
			// Create the target based on the distance and width from the center (keep going until it fits in the view)
			circleTarget = createTarget(distance, width);
			while(!circleTarget.isInside(view.bounds)) {
				circleTarget = createTarget(distance, width);
			}
			// Color the target circle active, and the center circle inactive
			circleTarget.fillColor = colorActive;
			circleCenter.fillColor = colorInactive;
			// Instantiate the path for the current target
			path = new Path();
			path.strokeColor = 'black';
			// Set the system as running
			running = true;
		}
		
		// If target circle is clicked ->
		if (circleTarget.contains(event.point) && running) {
			// Beep to notify the testee of the action
			beep();
			// Stop the system from running
			running = false;
			// Remove the target and its path (TODO: log it to array)
			circleTarget.remove();
			path.remove();
			// Update the remaining targets text
			remainingText.content = textRemaining + A.length;
			// Color the center circle active
			circleCenter.fillColor = colorActive;
			// If there are no remaining targets ->
			if (A.length < 1) {
				finished = true;
				circleCenter.remove();
				remainingText.remove();
				helpText.remove();
				finishedText = new PointText({
					point: view.center,
					justification: 'center',
					content: 'Finished!',
					fillColor: 'red',
					fontWeight: 'bold',
					fontSize: 20
				});
			}
		}
	}

	view.draw();
}