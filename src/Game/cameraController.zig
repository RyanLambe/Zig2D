const std = @import("std");
const cam = @import("../Engine/camera.zig");
const types = @import("../Engine/types.zig");

var player: *types.Object = undefined;

pub fn Start(setPlayer: *types.Object) void {
    player = setPlayer;
}

pub fn Update() void {
    //clamp to within world
    cam.pos.x = std.math.clamp(player.transform.pos.x, 0, 8);
    cam.pos.y = std.math.clamp(player.transform.pos.y, 0, 3);
}
