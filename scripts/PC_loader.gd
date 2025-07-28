class_name PointCloud_Loader extends Node3D

#@export_file()
#var file

class Point:
	var x : float
	var y : float
	var z : float
	var color : Color
	
	func _init(x, y, z, r, g, b):
		self.x = float(x)
		self.y = float(y)
		self.z = float(z)
		color = Color(float(r), float(g), float(b))


func read_csv(filename):
	
	var arr : Array[Point]
	
	var f = FileAccess.open(filename, FileAccess.READ)
	while not f.eof_reached():
		var s = f.get_csv_line(" ")
		if len(s) == 1:
			s = f.get_csv_line(",")
		arr.append(Point.new.callv(s))

	