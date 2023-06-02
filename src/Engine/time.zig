const std = @import("std");

var startTime: i64 = 0;
var lastFrame: f32 = undefined;

pub fn DeltaTime() f32 {
    if (lastFrame == undefined)
        return 0;
    return GetTime() - lastFrame;
}

pub fn Start() void {
    startTime = std.time.milliTimestamp();
}

pub fn Update() void {
    lastFrame = GetTime();
}

pub fn GetTime() f32 {
    return @intToFloat(f32, std.time.milliTimestamp() - startTime) / 1000.0;
}

pub fn GetFrame(fps: i32) i32 {
    return @divFloor(@truncate(i32, std.time.milliTimestamp() - startTime) * fps, 1000);
}
