const std = @import("std");
const c = @import("c.zig").c;

const shaders = @import("shaders.zig");
const types = @import("types.zig");
const objectHandler = @import("objectHandler.zig");
const camera = @import("camera.zig");

var width: c_int = undefined;
var height: c_int = undefined;

const cubeVertices = [_]f32{
    -0.5, -0.5,
    0.5,  -0.5,
    -0.5, 0.5,

    -0.5, 0.5,
    0.5,  -0.5,
    0.5,  0.5,
};

pub fn Start(glWidth: c_int, glHeight: c_int) void {
    //save window scale
    width = glWidth;
    height = glHeight;

    //setup buffers
    var vao: c_uint = undefined;
    var vbo: c_uint = undefined;

    c.glGenVertexArrays(1, &vao);
    c.glBindVertexArray(vao);

    c.glGenBuffers(1, &vbo);
    c.glBindBuffer(c.GL_ARRAY_BUFFER, vbo);
    c.glBufferData(c.GL_ARRAY_BUFFER, 12 * @sizeOf(f32), &cubeVertices, c.GL_STATIC_DRAW);

    //Link attributes
    c.glVertexAttribPointer(0, 2, c.GL_FLOAT, c.GL_FALSE, 2 * @sizeOf(f32), null);
    c.glEnableVertexAttribArray(0);

    //load shaders
    shaders.LoadShaders();
    objectHandler.Start();
}

pub fn Render() void {

    //update camera uniform
    var location: c_int = c.glGetUniformLocation(shaders.program, "camPos");
    c.glUniform2f(location, camera.pos.x, camera.pos.y);

    location = c.glGetUniformLocation(shaders.program, "camScale");
    c.glUniform1f(location, camera.scale);

    location = c.glGetUniformLocation(shaders.program, "aspectRatio");
    c.glUniform1f(location, @intToFloat(f32, width) / @intToFloat(f32, height));

    //render objects
    var objects = objectHandler.GetObjects();
    var i: usize = 0;
    while (i < objects.len) : (i += 1) {

        //update object uniform
        SetMatrixUniform(objects[i].transform.pos, objects[i].transform.rot, objects[i].transform.scale);

        location = c.glGetUniformLocation(shaders.program, "objectLayer");
        c.glUniform1i(location, @intCast(c_int, objects[i].transform.layer));

        location = c.glGetUniformLocation(shaders.program, "colour");
        c.glUniform3f(location, objects[i].graphic.colour.r, objects[i].graphic.colour.g, objects[i].graphic.colour.b);

        objects[i].graphic.PrepTexture();

        c.glDrawArrays(c.GL_TRIANGLES, 0, 6);
    }
}

fn SetMatrixUniform(pos: types.Vec2, rot: f32, scale: types.Vec2) void {
    var matrix = [_]f32{
        scale.x, 0,       pos.x,
        0,       scale.y, pos.y,
        0,       0,       1,
    };

    var location: c_int = c.glGetUniformLocation(shaders.program, "objectTransform");
    c.glUniformMatrix3fv(location, 1, c.GL_FALSE, &matrix[0]);

    var rrot = (-rot) * std.math.pi / 180.0;
    matrix = [_]f32{
        std.math.cos(rrot),  std.math.sin(rrot), 0,
        -std.math.sin(rrot), std.math.cos(rrot), 0,
        0,                   0,                  1,
    };
    location = c.glGetUniformLocation(shaders.program, "objectRotation");
    c.glUniformMatrix3fv(location, 1, c.GL_FALSE, &matrix[0]);
}

pub fn Stop() void {
    objectHandler.Stop();
}

pub fn SetSize(x: c_int, y: c_int) void {
    width = x;
    height = y;
}
