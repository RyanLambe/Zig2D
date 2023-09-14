const std = @import("std");
const types = @import("types.zig");

var count: u32 = 0;
const maxObjects: usize = 1024;
var objects: [maxObjects]types.Object = undefined;

pub fn Start() void {
    types.arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    types.allocator = types.arena.allocator();
}

pub fn CreateObject() *types.Object {

    // set data
    objects[count] = types.Object{ .id = count + 1 };
    objects[count].collider.object = &objects[count];
    objects[count].physics.object = &objects[count];

    // return
    count += 1;
    return &objects[count - 1];
}

pub fn GetObjects() []types.Object {
    return objects[0..];
}

pub fn Stop() void {
    types.arena.deinit();
}
