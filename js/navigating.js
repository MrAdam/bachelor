paper.install(window);

/*
 * Initialization
 */
if (typeof sessionStorage.data === "undefined") { $(location).attr('href', 'index.html') }
else { var data = JSON.parse(sessionStorage.data) }

/*
 * Variables
 */

// Original values from the article: Two Large Open-Access Datasets for Fitts’ Law of  Human Motion and a Succinct Derivation of the Square-Root Variant
var A = [250, 500, 750, 1000];
var W = [20, 30, 40, 50];
var W2 = 8;

var results = [];

var pathTool, path;
var helpText, remainingText;
var topWall, bottomWall, leftGate, rightGate;
var startTime, endTime;
var running = false;
var finished = false;

/*
 * Helper functions
 */

// Plays a beeping sound
var sound = new Audio('sound/beep.wav');
function beep() {
	sound.currentTime = 0;
	sound.play();
}

function onNext() {
	createTunnel();
	$('#next').hide();
	
}

function onContinue() {
	data.navigating = results;
	sessionStorage.data = JSON.stringify(data);
	$(location).attr('href', 'pointing.html');
}

// Create a tunnel width the specified distance and gate width
function createTunnel() {
	// Fetch the distance and width from the data
	var distance = A.shift();
	var width = W.shift();
	// Set the default options for the tunnel paths
	var options = { strokeColor: 'black', strokeWidth: 3, strokeCap: 'round' };
	// Instantiate the paths
	topWall = new Path(options);
	bottomWall = new Path(options);
	leftGate = new Path(options);
	rightGate = new Path(options);
	// Save the distance and width inside the leftGate data
	leftGate.data.distance = distance;
	leftGate.data.width = width;
	// Instantiate the coordinates for the tunnel based on the distance and width
	var topLeft = new Point(view.center.x - (distance / 2), view.center.y - (width / 2));
	var topRight = new Point(view.center.x + (distance / 2), view.center.y - (W2 / 2));
	var bottomLeft = new Point(view.center.x - (distance / 2), view.center.y + (width / 2));
	var bottomRight = new Point(view.center.x + (distance / 2), view.center.y + (W2 / 2));
	// Remove existing tunnel segments, and add the new ones
	topWall.removeSegments();
	topWall.add(topLeft, topRight);
	bottomWall.removeSegments();
	bottomWall.add(bottomLeft, bottomRight);
	leftGate.removeSegments();
	leftGate.add(topLeft, bottomLeft);
	rightGate.removeSegments();
	rightGate.add(topRight, bottomRight);
	// Color the left gate green
	leftGate.strokeColor = 'green';
	
	// Set up handler for mouseEnter on left gate
	leftGate.onMouseEnter = function(event) {
		// If the left gate was crossed and the test should start ->
		if (!running && !finished && event.event.movementX > 0) {
			// Beep to notify the testee of the action
			beep();
			// Instantiate the path for the current tunnel
			path = new Path();
			path.data.points = [];
			path.strokeColor = 'black';
			// Color the right gate green
			leftGate.strokeColor = 'black';
			rightGate.strokeColor = 'green';
			// Set the system as running
			running = true;
			startTime = performance.now();
		}
	}
	
	// Set up handler for mouseEnter on right gate
	rightGate.onMouseEnter = function(event) {
		// If the right gate was crossed and the test should stop ->
		if (running && !finished) {
			// Beep to notify the testee of the action
			beep();
			// Stop the system from running
			running = false;
			endTime = performance.now();
			// Add the data to the results
			results.push({
				distance: leftGate.data.distance,
				width: leftGate.data.width,
				points: path.data.points,
				time: endTime - startTime
			});
			// Remove the path and the tunnel
 			path.remove();
 			topWall.remove();
 			bottomWall.remove();
 			leftGate.remove();
 			rightGate.remove();
			// Update the remaining targets text
			remainingText.content = 'Resterende tunneler: ' + A.length;
			
			// If there are no remaining tunnels ->
			if (A.length < 1) {
				finished = true;
				remainingText.remove();
				helpText.remove();
				finishedText = new PointText({
					point: view.center,
					justification: 'center',
					content: 'Dine data er blevet registreret korrekt',
					fillColor: 'red',
					fontSize: 20
				});
				$('#continue').show();
			}
			// If there are tunnels left -> 
			else {
				$('#next').show();
			}
		}
	}
}

/*
 * Main program
 */

window.onload = function() {
	paper.setup('canvas');
	
	// Initialize texts and center circle
	helpText = new PointText({
		point: new Point(view.center.x, 30),
		justification: 'center',
		content: 'Før musen forbi den grønne streg, og derefter den næste så hurtigt du kan',
		fillColor: 'red',
		fontSize: 15
	});

	remainingText = new PointText({
		point: new Point(view.center.x, (view.center.y * 2) - 30),
		justification: 'center',
		content: 'Resterende tunneler: ' + A.length,
		fillColor: '#ccc',
		fontSize: 15
	});
	
	// Initialize first tunnel
	createTunnel();
	
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
	
	view.draw();
}