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
var A = [127, 190, 252, 315];
var Y = [0, 4, -5, -5];
var X = [25, 55, 55, 94, 94, 140, 109, 145];
var ThickVar = [0.01, 0.01, 0.01, 0.005];
var W2 = 8;

var results = [];

var pathTool, path;
var helpText, remainingText;
var leftGate, rightGate, spiral;
var startTime, endTime;
var running = false;
var finished = false;

/*
 * Helper functions
 */

var sound = new Audio('sound/beep.wav');
function beep() {
	sound.currentTime = 0;
	sound.play();
}

function onNext() {
	drawSpiral();
	$('#next').hide();
}

function onContinue() {
	data.navigating = results;
	sessionStorage.data = JSON.stringify(data);
	$(location).attr('href', 'pointing.html');
}



function drawSpiral() {
	var centerx = view.center.x;
	var centery = view.center.y;
	var options = { strokeColor: 'black', strokeWidth: 3, strokeCap: 'round' };
	spiral = new Path(options);
	leftGate = new Path(options);
	rightGate = new Path(options);
	spiral.removeSegments();
	leftGate.removeSegments();
	rightGate.removeSegments();
	
	spiral.add(new Point(centerx, centery));
	
	
	var endPoint = A.shift();
	var yPoint = Y.shift();
	var one = X.shift();
	var two = X.shift();
	var thick = ThickVar.shift();
	thickness = 3
	for (i = 0; i < endPoint; i++) {
		angle = 0.1 * i;
	    x = centerx + (2 + thickness * angle) * Math.cos(angle);
	    y = centery + (2 + thickness * angle) * Math.sin(angle);
		thickness = thickness+thick;
		spiral.add(new Point(x,y));
	    }
		
	leftGate.add(new Point(centerx, centery));
	leftGate.add(new Point(centerx+25, centery));
	rightGate.strokeColor = 'green';
	rightGate.add(new Point(centerx+one, centery+yPoint));
	rightGate.add(new Point(centerx+two, centery+yPoint));
	
	rightGate.onMouseEnter = function(event) {
		// If the left gate was crossed and the test should start ->
		if (!running && !finished) {
			// Beep to notify the testee of the action
			beep();
			// Instantiate the path for the current tunnel
			path = new Path();
			path.data.points = [];
			path.strokeColor = 'black';
			// Color the right gate green
			leftGate.strokeColor = 'green';
			rightGate.strokeColor = 'black';
			// Set the system as running
			running = true;
			startTime = performance.now();
		}
	}
	
	leftGate.onMouseEnter = function(event) {
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
 			spiral.remove();
			path.remove();
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
	
	drawSpiral();
	
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
