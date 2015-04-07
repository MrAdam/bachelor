paper.install(window);

var pathTool, path;
var center, target;
var running = false;
var W = [20, 30, 40, 50];
var endW = 8;
var A = [100, 250, 300, 400];
var topline, finishline, botline, startline;
var x1, x2, y1, y2, avalue;

function next() {
	if(A.length > 0)
	topline.remove();
	botline.remove();
	finishline.remove();
	startline.remove();
	path.remove();
	avalue = A.shift();
	wvalue = W.shift();
	x1 = view.center.x-(avalue/2);
	y1 = view.center.y-(wvalue/2);
	x2 = view.center.x+(avalue/2);
	y2 = view.center.y+(wvalue/2);
	topline = new Path.Line(new Point(x1,y1), new Point(x2,y1));
	botline = new Path.Line(new Point(x1,y2), new Point(x2,y1+8));
	startline = new Path.Rectangle(new Point(x1,y1), new Point(x1-3,y2));
	finishline = new Path.Rectangle(new Point(x2,y1), new Point(x2+3,y1+8));
	topline.strokeColor = "black";
	botline.strokeColor = "black";
	startline.strokeColor = "green";
	startline.fillColor = "green";
	finishline.strokeColor = "green";
	finishline.fillColor = "green";
}

window.onload = function() {
	
	paper.setup('canvas');
	avalue = A.shift();
	wvalue = W.shift();
	x1 = view.center.x-(avalue/2);
	y1 = view.center.y-(wvalue/2);
	x2 = view.center.x+(avalue/2);
	y2 = view.center.y+(wvalue/2);
	
	topline = new Path.Line(new Point(x1,y1), new Point(x2,y1));
	topline.strokeColor = "black";
	
	botline = new Path.Line(new Point(x1,y2), new Point(x2,y1+8));
	botline.strokeColor = "black";
	
	startline = new Path.Rectangle(new Point(x1,y1), new Point(x1-3,y2));
	startline.strokeColor = "green";
	startline.fillColor = "green";
	
	finishline = new Path.Rectangle(new Point(x2,y1), new Point(x2+3,y1+8));
	finishline.strokeColor = "green";
	finishline.fillColor = "green";
	
	// Setup path tool
	pathTool = new Tool();


	pathTool.onMouseMove = function(event) {
		if (running) {
			path.add(event.point);
		}
		if (startline.hitTest(event.point) != null && running == false && event.delta.x > 0) {
			path = new Path();
			running = true;
			path.strokeColor = 'blue';
			startline.strokeColor = "red";
			startline.fillColor = "red";
			return;
		}
		
		if (finishline.hitTest(event.point) != null && running == true && event.delta.x > 0) {
			finishline.strokeColor = "yellow";
			startline.strokeColor = "yellow";
			path.strokeColor = "yellow";
			startline.fillColor = "yellow";
			finishline.fillColor = "yellow";
			running = false;
			nextButton = $("#nextTunnel");
			nextButton.show();
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