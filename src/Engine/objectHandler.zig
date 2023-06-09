const std = @import("std");
const types = @import("types.zig");

var data: std.ArrayList(types.Object) = undefined;
var nextId: u32 = 1;

pub fn Start() void {
    data = std.ArrayList(types.Object).init(std.heap.page_allocator);
    types.arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    types.allocator = types.arena.allocator();
}

pub fn CreateObject() *types.Object {
    data.append(types.Object{ .id = nextId }) catch unreachable;
    nextId += 1;

    //give collider and physics references to object
    data.items[data.items.len - 1].collider.object = &data.items[data.items.len - 1];
    data.items[data.items.len - 1].physics.object = &data.items[data.items.len - 1];

    return &data.items[data.items.len - 1];
}

//todo check if it works properly
pub fn DeleteObject(object: *types.Object) void {
    var i: usize = 0;

    while (i < data.items.len) : (i += 1) {
        if (data.items[i].id == object.id) {
            _ = data.swapRemove(i);
            return;
        }
    }
}

pub fn GetObjects() []types.Object {
    return data.items;
}

pub fn Stop() void {
    data.deinit();
    types.arena.deinit();
}
