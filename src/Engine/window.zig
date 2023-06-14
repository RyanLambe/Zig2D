const std = @import("std");
const c = @import("c.zig").c;

const graphics = @import("graphics.zig");
const camera = @import("camera.zig");
const time = @import("time.zig");

//window properties
pub var window: *c.GLFWwindow = undefined;
var glWidth = @intCast(c_int, 0);
var glHeight = @intCast(c_int, 0);

var started = false;
var glfwStarted = false;
var windowCreated = false;

//callbacks for glfw
fn GlfwErrorCallback(err: c_int, description: [*c]const u8) callconv(.C) void {
    var desc = @constCast(description);
    std.debug.print("GLFW error {}: {s}\n", .{ err, desc });
}

fn WindowResized(_: ?*c.GLFWwindow, width: c_int, height: c_int) callconv(.C) void {
    glWidth = width;
    glHeight = height;

    c.glViewport(0, 0, glWidth, glHeight);
    graphics.SetSize(glWidth, glHeight);
}

//creates the window
pub fn Start(title: []const u8, width: c_int, height: c_int) void {
    //check if started
    if (started)
        return;

    started = true;

    _ = c.glfwSetErrorCallback(GlfwErrorCallback);

    //start glfw
    if (c.glfwInit() == c.GLFW_FALSE) {
        std.debug.print("failed to initialize GLFW\n", .{});
        Stop();
        std.process.exit(1);
    }
    glfwStarted = true;

    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MAJOR, 4);
    c.glfwWindowHint(c.GLFW_CONTEXT_VERSION_MINOR, 6);
    c.glfwWindowHint(c.GLFW_OPENGL_PROFILE, c.GLFW_OPENGL_CORE_PROFILE);

    //create window
    window = c.glfwCreateWindow(width, height, &title[0], null, null) orelse {
        std.debug.print("failed to create GLFW window\n", .{});
        Stop();
        std.process.exit(1);
    };
    windowCreated = true;

    c.glfwMakeContextCurrent(window);
    _ = c.gladLoadGL(c.glfwGetProcAddress);
    _ = c.glfwSetWindowSizeCallback(window, &WindowResized);

    c.glViewport(0, 0, width, height);
    c.glfwGetFramebufferSize(window, &glWidth, &glHeight);
    c.glEnable(c.GL_DEPTH_TEST);

    c.glEnable(c.GL_BLEND);
    c.glBlendFunc(c.GL_SRC_ALPHA, c.GL_ONE_MINUS_SRC_ALPHA);

    //unlock fps
    c.glfwSwapInterval(1);
    c.glfwSetInputMode(window, c.GLFW_STICKY_KEYS, c.GLFW_TRUE);

    graphics.Start(glWidth, glHeight);
}

//update the window
pub fn Update() void {

    //render
    c.glClearColor(camera.backgroundColour.r, camera.backgroundColour.g, camera.backgroundColour.b, 1.0);
    c.glClear(c.GL_COLOR_BUFFER_BIT | c.GL_DEPTH_BUFFER_BIT);
    graphics.Render();

    c.glfwSwapBuffers(window);
    c.glfwPollEvents();
}

pub fn ShouldClose() bool {
    return c.glfwWindowShouldClose(window) == c.GLFW_TRUE;
}

pub fn Stop() void {
    if (windowCreated)
        c.glfwDestroyWindow(window);
    if (glfwStarted)
        c.glfwTerminate();
    graphics.Stop();
}
