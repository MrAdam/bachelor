paper.install(window);

var pathTool, path;
var center, target;
var targets = [[200,150],[200,-150],[-200,150],[-200,-150]];
var running = false;

window.onload = function() {
	paper.setup('canvas');
	
	// Center circle
	center = new Path.Circle(view.center, 30);
	center.fillColor = 'red';
	
	// Target circle
	target = new Path.Circle(new Point(-100, -100), 30);
	target.fillColor = 'red';

	// Setup path tool
	pathTool = new Tool();

	pathTool.onMouseMove = function(event) {
		if (running) {
			path.add(event.point);
		}
	}
	
	pathTool.onMouseDown = function(event) {
		if (center.contains(event.point)) {
			// Center circle clicked
			if (!running) {
				center.fillColor = 'blue';
				target.position = view.center.add(targets[Math.floor(Math.random()*targets.length)]);
				path = new Path();
				path.strokeColor = 'black';
				running = true;
			}
		}
		
		if (target.contains(event.point)) {
			// Target circle clicked
			if (running) {
				running = false;
				path.remove();
				target.position = new Point(-100, -100);
				center.fillColor = 'red';
			}
		}
		
	}

	view.draw();
}