const std = @import("std");
const c = @import("c.zig").c;

var startTime: f32 = 0;
var lastFrame: f32 = undefined;

pub fn DeltaTime() f32 {
    if (lastFrame == undefined)
        return 0;
    return GetTime() - lastFrame;
}

pub fn Update() void {
    lastFrame = GetTime();
}

pub fn Calibrate(amount: f32) void {
    
    startTime += amount;
}

pub fn GetTime() f32 {
    return @floatCast(f32, c.glfwGetTime()) - startTime;
}

pub fn GetFrame(fps: i32) i32 {
    return @floatToInt(i32, GetTime() * @intToFloat(f32, fps));
}
