@tool

extends Node3D

var rd := RenderingServer.create_local_rendering_device()

@export_tool_button("Run shader", "Clickable") var h = run_shader


func run_shader():
	# Opening the shader
	var shader_file := load("res://compute_example.glsl")
	var shader_spirv : RDShaderSPIRV = shader_file.get_spirv()
	var shader := rd.shader_create_from_spirv(shader_spirv)

	# Setting up and formatting a buffer for input
	var input = PackedFloat64Array([2231.0, 20.0, 3.0, 4.0, 5.0, 6.0])
	var input_bytes = input.to_byte_array()
	var buffer = rd.storage_buffer_create(input_bytes.size(), input_bytes)

	# Setting up a uniform to transfer the buffer to the shader
	var uniform := RDUniform.new()
	uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	uniform.binding = 0
	uniform.add_id(buffer)
	var uniform_set := rd.uniform_set_create([uniform], shader, 0)

	# Setting up the render device pipeline so it can run
	var pipeline := rd.compute_pipeline_create(shader)
	var compute_list := rd.compute_list_begin()
	rd.compute_list_bind_compute_pipeline(compute_list, pipeline)
	rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
	rd.compute_list_dispatch(compute_list, 3, 1, 1) # 3 workgroups in X, each workgroup is (2 x 1 x 1) = array(6) like our input
	rd.compute_list_end()

	rd.submit()
	rd.sync()
 
	var output = rd.buffer_get_data(buffer).to_float64_array()
	print("Input: ", input)
	print("Output: ", output)

func _ready() -> void:
	run_shader()
