const std = @import("std");
const types = @import("types.zig");
const time = @import("time.zig");
const objectHandler = @import("objectHandler.zig");

pub var gravity: types.Vec2 = types.Vec2{ .x = 0, .y = -9.81 };

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

    //apply dynamics
    var i: usize = 0;
    while (i < objects.len) : (i += 1) {
        if (objects[i].physicsType != types.PhysicsType.PhysicsEnabled)
            continue;

        if (objects[i].physics.static)
            continue;


        //add gravity
        objects[i].physics.acceleration = types.Vec2.Add(objects[i].physics.acceleration, gravity);

        //apply forces
        objects[i].transform.pos = types.Vec2.Add(objects[i].transform.pos, types.Vec2.MulX(objects[i].physics.velocity, time.DeltaTime()));
        objects[i].transform.pos = types.Vec2.Add(objects[i].transform.pos, types.Vec2.MulX(objects[i].physics.acceleration, time.DeltaTime() * time.DeltaTime() * 0.5));
        objects[i].physics.velocity = types.Vec2.Add(objects[i].physics.velocity, types.Vec2.MulX(objects[i].physics.acceleration, time.DeltaTime()));
        
        //remove gravity
        objects[i].physics.acceleration = types.Vec2.Sub(objects[i].physics.acceleration, gravity);
    }

    //check for collisions
    i = 0;
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

    //solve for collisions
    i = 0;
    while (i < collisions.items.len) : (i += 1) {
        if (collisions.items[i].depth == -1)
            continue;

        if(collisions.items[i].objA.physicsType != types.PhysicsType.PhysicsEnabled)
            continue;

        if(collisions.items[i].objB.physicsType != types.PhysicsType.PhysicsEnabled)
            continue;

        //collision responces
        Position(collisions.items[i]);
        Impulse(collisions.items[i]);
    }

    collisions.deinit();
}

fn PositionOLD(collision: CollisionData) void {
    var totalMass: f32 = collision.objA.physics.mass + collision.objB.physics.mass;
    var correctionScale: f32 = collision.depth / totalMass;

    if (!collision.objA.physics.static) {
        collision.objA.transform.pos.x -= collision.Normal.x * (collision.objA.physics.mass * correctionScale);
        collision.objA.transform.pos.y -= collision.Normal.y * (collision.objA.physics.mass * correctionScale);
    }

    if (!collision.objB.physics.static) {
        collision.objB.transform.pos.x += collision.Normal.x * (collision.objB.physics.mass * correctionScale);
        collision.objB.transform.pos.y += collision.Normal.y * (collision.objB.physics.mass * correctionScale);
    }
}

fn Position(collision: CollisionData) void {
    
    var moveableObjects: f32 = 1;
    if ((!collision.objA.physics.static) and (!collision.objB.physics.static))
        moveableObjects = 2;

    if (!collision.objA.physics.static) {
        collision.objA.transform.pos.x -= collision.Normal.x * collision.depth / moveableObjects;
        collision.objA.transform.pos.y -= collision.Normal.y * collision.depth / moveableObjects;
    }

    if (!collision.objB.physics.static) {
        collision.objB.transform.pos.x += collision.Normal.x * collision.depth / moveableObjects;
        collision.objB.transform.pos.y += collision.Normal.y * collision.depth / moveableObjects;
    }
}

fn Impulse(collision: CollisionData) void {
    
    var vRel: types.Vec2 = undefined;
    if((!collision.objA.physics.static) and (!collision.objA.physics.static)){
        vRel = types.Vec2.Sub(collision.objA.physics.velocity, collision.objB.physics.velocity);
    }
    else if (!collision.objA.physics.static){
        vRel = collision.objA.physics.velocity;
    }
    else if (!collision.objB.physics.static){
        vRel = collision.objB.physics.velocity;
    }
    else{
        return;
    }

    var e: f32 = std.math.min(collision.objA.physics.elasticity, collision.objB.physics.elasticity);// 3 seems to be a perfect bounce
    var vDotN = types.Vec2.Dot(vRel, collision.Normal);

    var impulseMag: f32 = -(1 + e) * vDotN / ((1 / collision.objA.physics.mass) + (1 / collision.objB.physics.mass));
    var impulse: types.Vec2 = types.Vec2.MulX(collision.Normal, impulseMag);

    if(!collision.objA.physics.static)
        collision.objA.physics.ApplyImpulse(impulse);
    if(!collision.objB.physics.static)
        collision.objB.physics.ApplyImpulse(types.Vec2.MulX(impulse, -1));
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

    //get positions
    var ax = a.transform.pos.x + a.collider.colliderOffset.x;
    var ay = a.transform.pos.y + a.collider.colliderOffset.y;

    var bx = b.transform.pos.x + b.collider.colliderOffset.x;
    var by = b.transform.pos.y + b.collider.colliderOffset.y;

    //check if collision
    var distance: f32 = std.math.sqrt(((bx - ax) * (bx - ax)) + ((by - ay) * (by - ay)));
    if (distance > a.collider.colliderScale.circle + b.collider.colliderScale.circle)
        return CollisionData{ .hit = false };

    //tell objects about collision
    a.collider.CollisionCallback(b);
    b.collider.CollisionCallback(a);

    //return collision data
    var data = CollisionData{ .hit = true };

    distance = std.math.max(distance, 0.000001);
    var toB = types.Vec2{ .x = (bx - ax) / distance, .y = (by - ay) / distance };

    data.objA = a;
    data.objB = b;
    data.A = types.Vec2{ .x = ax + a.collider.colliderScale.circle * toB.x, .y = ay + a.collider.colliderScale.circle * toB.y };
    data.B = types.Vec2{ .x = bx + b.collider.colliderScale.circle * -toB.x, .y = by + b.collider.colliderScale.circle * -toB.y };
    data.depth = std.math.sqrt(((data.B.x - data.A.x) * (data.B.x - data.A.x)) + ((data.B.y - data.A.y) * (data.B.y - data.A.y)));
    data.depth = std.math.max(data.depth, 0.000001);
    data.Normal = types.Vec2{ .x = (data.A.x - data.B.x) / data.depth, .y = (data.A.y - data.B.y) / data.depth };

    return data;
}

fn RectAndCircle(rect: *types.Object, circle: *types.Object) CollisionData {

    //get positions of rect and circle
    var ax = rect.transform.pos.x + rect.collider.colliderOffset.x;
    var axs = (rect.collider.colliderScale.rect.x / 2);
    var ay = rect.transform.pos.y + rect.collider.colliderOffset.y;
    var ays = (rect.collider.colliderScale.rect.y / 2);

    var bx = circle.transform.pos.x + circle.collider.colliderOffset.x;
    var by = circle.transform.pos.y + circle.collider.colliderOffset.y;

    //get distance between objects
    var distanceX: f32 = std.math.max(ax - axs, std.math.min(bx, ax + axs)) - bx;
    var distanceY: f32 = std.math.max(ay - ays, std.math.min(by, ay + ays)) - by;

    var distance: f32 = std.math.sqrt((distanceX * distanceX) + (distanceY * distanceY));
    distance = std.math.max(distance, 0.000001);

    //check if collision
    if (distance > circle.collider.colliderScale.circle)
        return CollisionData{ .hit = false };

    //tell objects about collision
    rect.collider.CollisionCallback(circle);
    circle.collider.CollisionCallback(rect);

    //return collision data
    var data = CollisionData{ .hit = true };
    data.objA = rect;
    data.objB = circle;
    data.depth = circle.collider.colliderScale.circle - distance;
    data.Normal = types.Vec2{ .x = -distanceX / distance, .y = -distanceY / distance };

    return data;
}
