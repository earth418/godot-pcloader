@tool
class_name PointCloud_Loader extends Node3D

#@export_file()
#var file

@export_tool_button("Make particles", "Click") var j = go_parts


class Point:
	#var x : float
	#var y : float
	#var z : float
	var pos : Vector3
	var color : Color
	
	func _init(ix, iy, iz, r, g=null, b=null):
		pos.x = float(ix)
		pos.y = float(iy)
		pos.z = float(iz)
		if b != null:
			color = Color(float(r), float(g), float(b))
		elif g == null:
			color = r
		else:
			color = Color.BLACK
	

func read_csv(filename) -> Array[Point]:
	
	var arr : Array[Point]
	
	# temp
	var color_map = {"building" : Color.GRAY, "tree" : Color.GREEN}
	
	var f = FileAccess.open(filename, FileAccess.READ)
	while not f.eof_reached():
		var s = f.get_csv_line(" ")
		if len(s) == 1:
			s = f.get_csv_line(",")
		print(s)
		arr.append(Point.new(s[0], s[1], s[2], color_map[s[3]]))
	
	return arr

func go_parts():
	
	var points = read_csv("res://labeled_city_view.txt")
	
	var sz = len(points)
	
	var pos_img = Image.new()
	var col_img = Image.new()
	#pos_img.resize(sz, 1)
	#col_img.resize(sz, 1)
	var carr = []
	var parr = []
	
	print(points)
	return
	
	for i in range(sz):
		carr.append(points[i].color)
		parr.append(points[i].pos)
		#pos_img.set_pixel(i,0,points[i].pos)
		#col_img.set_pixel(i,0,points[i].color)
	col_img.set_data(sz/2, 2,false,Image.FORMAT_RG8,carr)
	pos_img.set_data(sz/2, 2,false,Image.FORMAT_RG8,parr)
	
	
	var mat : ParticleProcessMaterial = load("res://node_3d.tscn::ParticleProcessMaterial_a202f")
	mat.emission_point_texture = ImageTexture.create_from_image(pos_img)
	mat.emission_color_texture = ImageTexture.create_from_image(col_img)
