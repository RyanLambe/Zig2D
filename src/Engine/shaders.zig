const std = @import("std");
const c = @import("c.zig").c;

pub var program: c_uint = undefined;

pub fn LoadShaders() void {

    //load vertex shader
    var vertexShader: c_uint = c.glCreateShader(c.GL_VERTEX_SHADER);
    c.glShaderSource(vertexShader, 1, &&@embedFile("shaders/VertexShader.glsl")[0], null);
    c.glCompileShader(vertexShader);

    //check for errors
    var success: c_int = undefined;
    var infoLog: [512]u8 = undefined;
    c.glGetShaderiv(vertexShader, c.GL_COMPILE_STATUS, &success);
    if (success != 1) {
        c.glGetShaderInfoLog(vertexShader, 512, null, &infoLog[0]);
        std.debug.print("cannot load vertex shader: \n{s}\n\n", .{infoLog});
    }

    //load fragment shader
    var fragmentShader: c_uint = c.glCreateShader(c.GL_FRAGMENT_SHADER);
    c.glShaderSource(fragmentShader, 1, &&@embedFile("shaders/FragmentShader.glsl")[0], null);
    c.glCompileShader(fragmentShader);

    //check for errors
    c.glGetShaderiv(fragmentShader, c.GL_COMPILE_STATUS, &success);
    if (success != 1) {
        c.glGetShaderInfoLog(fragmentShader, 512, null, &infoLog[0]);
        std.debug.print("cannot load fragment shader: {s}\n", .{infoLog});
    }

    //create shader program
    program = c.glCreateProgram();
    c.glAttachShader(program, vertexShader);
    c.glAttachShader(program, fragmentShader);
    c.glLinkProgram(program);

    //check for errors
    c.glGetProgramiv(program, c.GL_LINK_STATUS, &success);
    if (success != 1) {
        c.glGetProgramInfoLog(program, 512, null, &infoLog[0]);
        std.debug.print("cannot create shader program: {s}\n", .{infoLog});
    }

    c.glUseProgram(program);
    c.glDeleteShader(vertexShader);
    c.glDeleteShader(fragmentShader);
}
