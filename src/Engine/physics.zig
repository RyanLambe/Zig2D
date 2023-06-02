const types = @import("types.zig");
const objectHandler = @import("objectHandler.zig");

pub fn PhysicsUpdate() void {
    var objects = objectHandler.GetObjects();

    var i: usize = 0;
    while (i < objects.len) : (i += 1) {

        //check if collision is enabled
        if (objects[i].physicsType == types.PhysicsType.None) {
            continue;
        }

        var j: usize = 0;
        while (j < objects.len) : (j += 1) {

            //check if collision is enabled
            if (objects[j].physicsType == types.PhysicsType.None) {
                continue;
            }

            //check if collision between i and j

        }
    }
}
