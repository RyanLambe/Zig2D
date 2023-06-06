const std = @import("std");
const types = @import("types.zig");
const objectHandler = @import("objectHandler.zig");

pub fn Update() void {
    var objects = objectHandler.GetObjects();

    var i: usize = 0;
    while (i < objects.len) : (i += 1) {

        //check if collision is enabled
        if (objects[i].physicsType == types.PhysicsType.None) {
            continue;
        }

        var j: usize = i + 1;
        while (j < objects.len) : (j += 1) {

            //check if collision is enabled
            if (objects[j].physicsType == types.PhysicsType.None)
                continue;

            if (!CheckCollision(&objects[i], &objects[j]))
                continue;

            //physics stuff
            //todo
        }
    }
}

fn CheckCollision(a: *types.Object, b: *types.Object) bool {
    if (a.circleCollider) {
        if (b.circleCollider) {
            return CircleAndCircle(a, b);
        } else {
            return RectAndCircle(b, a);
        }
    } else {
        if (b.circleCollider) {
            return RectAndCircle(a, b);
        } else {
            return RectAndRect(a, b);
        }
    }
}

fn RectAndRect(a: *types.Object, b: *types.Object) bool {

    //check x axis
    var ax = a.pos.x + a.colliderOffset.x;
    var axs = (a.colliderScale.rect.x / 2);
    var bx = b.pos.x + b.colliderOffset.x;
    var bxs = (b.colliderScale.rect.x / 2);

    if (bx - bxs > ax + axs) return false;
    if (bx + bxs < ax - axs) return false;

    //check y axis
    var ay = a.pos.y + a.colliderOffset.y;
    var ays = (a.colliderScale.rect.y / 2);
    var by = b.pos.y + b.colliderOffset.y;
    var bys = (b.colliderScale.rect.y / 2);

    if (by - bys > ay + ays) return false;
    if (by + bys < ay - ays) return false;

    //tell objects about collision
    a.CollisionCallback(b);
    b.CollisionCallback(a);

    return true;
}

fn CircleAndCircle(a: *types.Object, b: *types.Object) bool {

    //get origin
    var ax = a.pos.x + a.colliderOffset.x;
    var ay = a.pos.y + a.colliderOffset.y;

    var bx = b.pos.x + b.colliderOffset.x;
    var by = b.pos.y + b.colliderOffset.y;

    //check if intersecting
    var distance: f32 = std.math.sqrt(((bx - ax) * (bx - ax)) + ((by - ay) * (by - ay)));
    if (distance > a.colliderScale.circle + b.colliderScale.circle)
        return false;

    //tell objects about collision
    a.CollisionCallback(b);
    b.CollisionCallback(a);

    return true;
}

fn RectAndCircle(rect: *types.Object, circle: *types.Object) bool {

    //get position of circle, clamped to within rect (closest point to circle)
    var rx = rect.pos.x + rect.colliderOffset.x;
    var rxs = (rect.colliderScale.rect.x / 2);
    var ry = rect.pos.y + rect.colliderOffset.y;
    var rys = (rect.colliderScale.rect.y / 2);

    var cx = std.math.clamp(circle.pos.x, rx - rxs, rx + rxs);
    var cy = std.math.clamp(circle.pos.y, ry - rys, ry + rys);

    //check distance between clamped pos and circle pos
    var distance: f32 = std.math.sqrt(((cx - circle.pos.x) * (cx - circle.pos.x)) + ((cy - circle.pos.y) * (cy - circle.pos.y)));
    if (distance > circle.colliderScale.circle)
        return false;

    //tell objects about collision
    circle.CollisionCallback(rect);
    rect.CollisionCallback(circle);

    return true;
}
