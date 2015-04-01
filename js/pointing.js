paper.install(window);

var pathTool, path;
var center, target;
//var targets = [[200,150],[200,150],[200,150],[200,150]];
var dist = [67, 184, 280, 230, 144, 249, 255, 96, 225, 263, 259, 229, 215, 198, 301, 194, 260, 296, 180, 278, 283, 40, 233, 191, 179]
var size = [20, 38, 14, 29, 55, 29, 14, 50, 19, 12, 25, 20, 31, 83, 16, 66, 12, 14, 44, 11, 37, 32, 10, 50, 18]
var running = false;
var counter = 0;

window.onload = function() {
	paper.setup('canvas');
	
	// Center circle
	center = new Path.Circle(view.center, 15);
	center.fillColor = 'red';
	
	// Target circle
	//target = new Path.Circle(new Point(-100, -100), 30);
	//target.fillColor = 'red';

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
				ran_angle = Math.floor(Math.random()*361);

				x = dist[counter] * Math.cos(ran_angle * Math.PI/180);
				y = dist[counter] * Math.sin(ran_angle * Math.PI/180);

				x += view.center.x
				y += view.center.y

				center.fillColor = 'green';
				target = new Path.Circle(new Point(x,y), size[counter]);
				target.fillColor = 'red';
				path = new Path();
				path.strokeColor = 'black';
				running = true;
				counter++;
			}
		}
		
		if (target.contains(event.point)) {
			// Target circle clicked
			if (running) {
				running = false;
				path.remove();
				target.remove();
				center.fillColor = 'red';
			}
		}
		
	}

	view.draw();
}