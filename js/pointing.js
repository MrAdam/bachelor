paper.install(window);

/*
 * Initialization
 */
if (sessionStorage.data == "null") { window.location.replace('index.html'); }
var data = JSON.parse(sessionStorage.data);

/*
 * Variables
 */

// Original values from the article: Two Large Open-Access Datasets for Fitts’ Law of  Human Motion and a Succinct Derivation of the Square-Root Variant
// var A = [67, 184, 280, 230, 144, 249, 255, 96, 225, 263, 259, 229, 215, 198, 301, 194, 260, 296, 180, 278, 283, 40, 233, 191, 179];
// var W = [20, 38, 14, 29, 55, 29, 14, 50, 19, 12, 25, 20, 31, 83, 16, 66, 12, 14, 44, 11, 37, 32, 10, 50, 18];
var A = [50, 60, 70];
var W = [50, 60, 70];
var results = [];

var pathTool, path;
var centerCircle, targetCircle;
var startTime, endTime;
var targetColor = 'green';
var nonTargetColor = 'blue';
var running = false;
var finished = false;

/*
 * Helper functions
 */

// Plays a beeping sound
function beep() {
	var sound = new Audio('sound/beep.wav');
	sound.play();
}

// Creates a new target with specified width, and specified distance from center (at random angle)
function createTarget(distance, width) {
	var angle = Math.floor(Math.random()*361);
	var x = (distance * Math.cos(angle * Math.PI/180)) + view.center.x;
	var y = (distance * Math.sin(angle * Math.PI/180)) + view.center.y;
	var target = new Path.Circle(new Point(x,y), width / 2);
	target.data.distance = distance;
	target.data.width = width;
	return target;
}

// Returns the average time of results
function average() {
	var sum = 0;
	for (i = 0; i < results.length; i++) {
		sum += results[i].time;
	}
	return sum / results.length;
}

function onContinue() {
	data.pointing = results;
	sessionStorage.data = JSON.stringify(data);
	window.location.replace('navigating.html');
}

/*
 * Main program
 */

window.onload = function() {
	paper.setup('canvas');
	
	// Initialize texts and center circle
	var helpText = new PointText({
		point: new Point(view.center.x, 30),
		justification: 'center',
		content: 'When a green circle appears, click on it as fast as possible',
		fillColor: 'red',
		fontSize: 15
	});

	var remainingText = new PointText({
		point: new Point(view.center.x, (view.center.y * 2) - 30),
		justification: 'center',
		content: 'Targets remaining: ' + A.length,
		fillColor: '#ccc',
		fontSize: 15
	});
	
	centerCircle = new Path.Circle({
		center: view.center,
		radius: 20,
		fillColor: targetColor
	});

	// Initialize path tool, and set up its functions
	pathTool = new Tool();
	
	pathTool.onMouseMove = function(event) {
		if (running) {
			path.add(event.point);
			var lastPoint = path.data.points[path.data.points.length - 1];
			path.data.points.push({
				x: event.point.x,
				y: event.point.y,
				elapsedTime: performance.now() - startTime,
				deltaTime: lastPoint != undefined ? (performance.now() - startTime) - lastPoint.elapsedTime : performance.now() - startTime,
				deltaDistance: event.delta.length
			});
		}
	}
	
	pathTool.onMouseDown = function(event) {
		// If center circle is clicked, and a new target is needed ->
		if (centerCircle.contains(event.point) && !running && !finished) {
			// Beep to notify the testee of the action
			beep();
			// Fetch the next A (distance) and W (width)
			var distance = A.shift();
			var width = W.shift();
			// Create the target based on the distance and width from the center (keep going until it fits in the view)
			targetCircle = createTarget(distance, width);
			while(!targetCircle.isInside(view.bounds)) {
				targetCircle = createTarget(distance, width);
			}
			// Color the target circle active, and the center circle inactive
			targetCircle.fillColor = targetColor;
			centerCircle.fillColor = nonTargetColor;
			// Remove the help text
			helpText.remove();
			// Instantiate the path for the current target
			path = new Path();
			path.data.points = [];
			path.strokeColor = 'black';
			// Set the system as running
			running = true;
			startTime = performance.now();
		}
		
		// If target circle is clicked ->
		if (targetCircle.contains(event.point) && running) {
			// Beep to notify the testee of the action
			beep();
			// Stop the system from running
			running = false;
			endTime = performance.now();
			// Add the data to the results
			results.push({
				distance: targetCircle.data.distance,
				width: targetCircle.data.width,
				points: path.data.points,
				time: endTime - startTime
			});
			// Remove the target and its path
			targetCircle.remove();
			path.remove();
			// Update the remaining targets text
			remainingText.content = 'Targets remaining: ' + A.length;
			// Color the center circle active
			centerCircle.fillColor = targetColor;
			
			// If there are no remaining targets ->
			if (A.length < 1) {
				finished = true;
				centerCircle.remove();
				remainingText.remove();
				helpText.remove();
				finishedText = new PointText({
					point: view.center,
					justification: 'center',
					content: 'Your data has been recorded successfully',
					fillColor: 'red',
					fontSize: 20
				});
				averageText = new PointText({
					point: new Point(view.center.x, view.center.y + 20),
					justification: 'center',
					content: 'Your average response time was ' + Math.round(average()) + ' msec',
					fillColor: 'red',
					fontSize: 20
				});
				$('#continue').show();
			}
		}
	}

	view.draw();
}