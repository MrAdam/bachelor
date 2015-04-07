paper.install(window);

var pathTool, path;
var center, target;
var running = false;
var startW = [20, 30, 40, 50];
var endW = 8;
var A = [250, 500, 750, 1000];

window.onload = function() {
	
	paper.setup('canvas');

	var topline = new Path.Line(new Point(30,250), new Point(500,250));
	topline.strokeColor = "black"
	botline = new Path.Line(new Point(30,270), new Point(500,258));
	botline.strokeColor = "black";
	
	var startline = new Path.Rectangle(new Point(30,250), new Point(32,270));
	startline.strokeColor = "green";
	startline.fillColor = "green";
	
	var finishline = new Path.Rectangle(new Point(500,250), new Point(502,258));
	finishline.strokeColor = "green";
	finishline.fillColor = "green";
	
	var next = new Path.Rectangle(new Point(250,300), new Point(255,308))
	next.strokeColor = "green";
	next.fillColor = "green";
	
	// Setup path tool
	pathTool = new Tool();


	pathTool.onMouseMove = function(event) {
		if (running) {
			path.add(event.point);
		}
		if (startline.hitTest(event.point) != null && running == false && event.delta.x > 0) {
			path = new Path();
			path.strokeColor = 'blue';
			startline.strokeColor = "red";
			startline.fillColor = "red";
			running = true;
		}
		
		if (finishline.hitTest(event.point) != null && running == true && event.delta.x > 0) {
			finishline.strokeColor = "yellow";
			startline.strokeColor = "yellow";
			path.strokeColor = "yellow";
			startline.fillColor = "yellow";
			finishline.fillColor = "yellow";
			running = false;
			
			
			
		}
		
	}
	
	pathTool.onMouseDown = function(event) {
		if (finishline.contains(event.point)) {
				rect.fillColor = "red";
				running = false;
		}
	}

	view.draw();
}