const window = @import("Engine/window.zig");
const types = @import("Engine/types.zig");

pub const WindowName: []const u8 = "Game";

pub const DefaultWidth: c_int = 1280;
pub const DefaultHeight: c_int = 720;

pub fn SetWindowSize(size: types.Vec2) void {
    window.c.glfwSetWindowSize(window.window, @intFromFloat(size.x), @intFromFloat(size.y));
}

pub fn GetWindowSize() types.Vec2 {
    return window.GetWindowSize();
}
