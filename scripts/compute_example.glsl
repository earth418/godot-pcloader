#[compute]
#version 450

#extension EXT_shader_explicit_arithmetic_types_int64 : enable

struct PointCloudBatch
{
    vec3 Min;
    uint Offset;
    vec3 Max;
    uint Count;
};

struct PointCloudPixelAttributes {
    uint colorCount; 
    ivec3 color;
    uint depth;
    ivec3 pad;
};

layout(set = 1, binding = 1) restrict readonly buffer CloudBatches {
    PointCloudBatch data[];
};

layout(set = 2, binding = 1) restrict buffer CloudColors {
    uint colors[];
    uint positionsLw[];
    uint positionsMd[];
    uint positionsHi[];
};


// Invocations in the (x, y, z) dimension
layout(local_size_x = 2, local_size_y = 1, local_size_z = 1) in;

// A binding to the buffer we create in our script
layout(set = 0, binding = 0, std430) restrict buffer MyDataBuffer {
    double data[];
}
my_data_buffer;

// The code we want to execute in each invocation
void main() {
    // gl_GlobalInvocationID.x uniquely identifies this invocation across all work groups
    my_data_buffer.data[gl_GlobalInvocationID.x] = my_data_buffer.data[gl_GlobalInvocationID.x] * 2.0lf;
}