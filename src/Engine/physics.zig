const std = @import("std");
const types = @import("types.zig");
const objectHandler = @import("objectHandler.zig");

const CollisionData = struct {
    objA: *types.Object = undefined,
    objB: *types.Object = undefined,
    A: types.Vec2 = types.Vec2{},
    B: types.Vec2 = types.Vec2{},
    Normal: types.Vec2 = types.Vec2{},
    depth: f32 = -1,
    hit: bool,
};

pub fn Update() void {
    var objects = objectHandler.GetObjects();
    var collisions = std.ArrayList(CollisionData).init(std.heap.page_allocator);

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

            var collision = CheckCollision(&objects[i], &objects[j]);
            if (collision.hit)
                collisions.append(collision) catch unreachable;
        }
    }

    i = 0;
    while (i < collisions.items.len) : (i += 1) {
        if (collisions.items[i].depth == -1)
            continue;

        //do stuff
        positionSolver(collisions.items[i]);
    }

    collisions.deinit();
}

fn CheckCollision(a: *types.Object, b: *types.Object) CollisionData {
    if (a.collider.circleCollider) {
        if (b.collider.circleCollider) {
            return CircleAndCircle(a, b);
        } else {
            return RectAndCircle(b, a);
        }
    } else {
        if (b.collider.circleCollider) {
            return RectAndCircle(a, b);
        } else {
            return RectAndRect(a, b);
        }
    }
}

fn RectAndRect(a: *types.Object, b: *types.Object) CollisionData {

    //check x axis
    var ax = a.transform.pos.x + a.collider.colliderOffset.x;
    var axs = (a.collider.colliderScale.rect.x / 2);
    var bx = b.transform.pos.x + b.collider.colliderOffset.x;
    var bxs = (b.collider.colliderScale.rect.x / 2);

    if (bx - bxs > ax + axs) return CollisionData{ .hit = false };
    if (bx + bxs < ax - axs) return CollisionData{ .hit = false };

    //check y axis
    var ay = a.transform.pos.y + a.collider.colliderOffset.y;
    var ays = (a.collider.colliderScale.rect.y / 2);
    var by = b.transform.pos.y + b.collider.colliderOffset.y;
    var bys = (b.collider.colliderScale.rect.y / 2);

    if (by - bys > ay + ays) return CollisionData{ .hit = false };
    if (by + bys < ay - ays) return CollisionData{ .hit = false };

    //tell objects about collision
    a.collider.CollisionCallback(b);
    b.collider.CollisionCallback(a);

    //return collision data
    var data = CollisionData{ .hit = true };

    data.objA = a;
    data.objB = b;

    var overlapX: f32 = (axs + bxs) - std.math.fabs(ax - bx);
    var overlapY: f32 = (ays + bys) - std.math.fabs(ay - by);

    if (overlapX < overlapY) {
        if (ax - bx < 0) {
            data.Normal = types.Vec2{ .x = 1.0, .y = 0 };
        } else {
            data.Normal = types.Vec2{ .x = -1.0, .y = 0 };
        }
        data.depth = overlapX;
    } else {
        if (ay - by < 0) {
            data.Normal = types.Vec2{ .x = 0, .y = 1.0 };
        } else {
            data.Normal = types.Vec2{ .x = 0, .y = -1.0 };
        }
        data.depth = overlapY;
    }

    return data;
}

fn CircleAndCircle(a: *types.Object, b: *types.Object) CollisionData {

    //get origin
    var ax = a.transform.pos.x + a.collider.colliderOffset.x;
    var ay = a.transform.pos.y + a.collider.colliderOffset.y;

    var bx = b.transform.pos.x + b.collider.colliderOffset.x;
    var by = b.transform.pos.y + b.collider.colliderOffset.y;

    //check if intersecting
    var distance: f32 = std.math.sqrt(((bx - ax) * (bx - ax)) + ((by - ay) * (by - ay)));
    if (distance > a.collider.colliderScale.circle + b.collider.colliderScale.circle)
        return CollisionData{ .hit = false };

    //tell objects about collision
    a.collider.CollisionCallback(b);
    b.collider.CollisionCallback(a);

    //return collision data
    var data = CollisionData{ .hit = true };

    data.objA = a;
    data.objB = b;
    //data.A = ???;
    //data.B = ???;
    data.depth = std.math.sqrt(((data.B.x - data.A.x) * (data.B.x - data.A.x)) + ((data.B.y - data.A.y) * (data.B.y - data.A.y)));
    data.Normal = types.Vec2{ .x = data.B.x - data.A.x, .y = data.B.y - data.A.y };
    data.Normal.x /= data.depth;
    data.Normal.y /= data.depth;

    return data;
}

fn RectAndCircle(rect: *types.Object, circle: *types.Object) CollisionData {

    //get position of circle, clamped to within rect (closest point to circle)
    var rx = rect.transform.pos.x + rect.collider.colliderOffset.x;
    var rxs = (rect.collider.colliderScale.rect.x / 2);
    var ry = rect.transform.pos.y + rect.collider.colliderOffset.y;
    var rys = (rect.collider.colliderScale.rect.y / 2);

    var ax = circle.transform.pos.x + circle.collider.colliderOffset.x;
    var ay = circle.transform.pos.y + circle.collider.colliderOffset.y;

    var cx = std.math.clamp(ax, rx - rxs, rx + rxs);
    var cy = std.math.clamp(ay, ry - rys, ry + rys);

    //check distance between clamped pos and circle pos
    var distance: f32 = std.math.sqrt(((cx - ax) * (cx - ax)) + ((cy - ay) * (cy - ay)));
    if (distance > circle.collider.colliderScale.circle)
        return CollisionData{ .hit = false };

    //tell objects about collision
    circle.collider.CollisionCallback(rect);
    rect.collider.CollisionCallback(circle);

    //return collision data
    var data = CollisionData{ .hit = true };

    data.objA = rect;
    data.objB = circle;
    //data.A = ???;
    //data.B = ???;
    data.depth = std.math.sqrt(((data.B.x - data.A.x) * (data.B.x - data.A.x)) + ((data.B.y - data.A.y) * (data.B.y - data.A.y)));
    data.Normal = types.Vec2{ .x = data.B.x - data.A.x, .y = data.B.y - data.A.y };
    data.Normal.x /= data.depth;
    data.Normal.y /= data.depth;

    return data;
}

fn positionSolver(collisionData: CollisionData) void {
    var totalMass: f32 = collisionData.objA.physics.mass + collisionData.objB.physics.mass;
    var correctionScale: f32 = collisionData.depth / totalMass;

    if (!collisionData.objA.physics.static) {
        collisionData.objA.transform.pos.x -= collisionData.Normal.x * (collisionData.objA.physics.mass * correctionScale);
        collisionData.objA.transform.pos.y -= collisionData.Normal.y * (collisionData.objA.physics.mass * correctionScale);
    }

    if (!collisionData.objB.physics.static) {
        collisionData.objB.transform.pos.x += collisionData.Normal.x * (collisionData.objB.physics.mass * correctionScale);
        collisionData.objB.transform.pos.y += collisionData.Normal.y * (collisionData.objB.physics.mass * correctionScale);
    }
}
