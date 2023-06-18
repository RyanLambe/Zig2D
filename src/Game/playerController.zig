const std = @import("std");
const types = @import("../Engine/types.zig");
const objectHandler = @import("../Engine/objectHandler.zig");
const input = @import("../Engine/Input.zig");
const time = @import("../Engine/time.zig");

const assets = @import("assets.zig");

//character object
var object: *types.Object = undefined;

var playerSpeed: f32 = 5;
var jumpForce: f32 = 8;

var grounded: bool = true;
var right: bool = true;

pub fn Start() *types.Object {

    //create player object
    object = objectHandler.CreateObject();
    object.transform.scale = types.Vec2{ .x = 1, .y = 1 };

    //setup player physics
    object.collider.SetRectCollision(types.Vec2{ .x = 0.4, .y = 0.65 }, types.Vec2{ .x = 0, .y = 0 }, true);
    object.collider.SetCollisionCallback(CollisionCallback);

    //return player object to be used in camera
    return object;
}

pub fn Update() void {
    //move
    if (input.GetKey(input.KEY_A)) {
        object.transform.pos.x -= playerSpeed * time.DeltaTime();
        assets.PlayRunLeftGraphic(&object.graphic);
        right = false;
    } else if (input.GetKey(input.KEY_D)) {
        object.transform.pos.x += playerSpeed * time.DeltaTime();
        assets.PlayRunRightGraphic(&object.graphic);
        right = true;
    } else {
        if (right) {
            assets.PlayIdleRightGraphic(&object.graphic);
        } else {
            assets.PlayIdleLeftGraphic(&object.graphic);
        }
    }

    //jump
    if ((input.GetKey(input.KEY_SPACE) or input.GetKey(input.KEY_W)) and grounded) {
        object.physics.velocity.y += jumpForce;
        grounded = false;
    }

    //play jump graphic
    if (!grounded) {
        if (right) {
            assets.PlayJumpRightGraphic(&object.graphic);
        } else {
            assets.PlayJumpLeftGraphic(&object.graphic);
        }
    }

    //clamp to within world
    object.transform.pos.x = std.math.clamp(object.transform.pos.x, -4.75, 12.75);
}

fn CollisionCallback(other: *types.Object) void {
    _ = other;
    grounded = true;
}
