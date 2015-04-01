paper.install(window);

var pathTool, path;
var center, target;
var running = false;

window.onload = function() {
	
	paper.setup('canvas');

	var from = new Point(100,100);
	var to = new Point(600, 200);
	var line = new Path.Line(from, to);
	line.strokeColor = "black"
	from = new Point(100,300);
	to = new Point(600, 208);
	line = new Path.Line(from, to);
	line.strokeColor = "black";
	
	var rect = new Path.Rectangle(new Point(70,100), new Point(100,300));
	rect.fillColor = "red";
	rect.strokeColor = "black";
	
	// Setup path tool
	pathTool = new Tool();

	pathTool.onMouseMove = function(event) {
		if (running) {
			path.add(event.point);
		}
	}
	
	pathTool.onMouseDown = function(event) {
		if (rect.contains(event.point)) {
			if (!running) {
				path = new Path();
				path.strokeColor = 'black';
				rect.fillColor = "green";
				running = true;
			}
		}
	}

	view.draw();
}