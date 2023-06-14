const std = @import("std");
const input = @import("../Engine/input.zig");
const objectHandler = @import("../Engine/objectHandler.zig");
const types = @import("../Engine/types.zig");
const time = @import("../Engine/time.zig");

const aTexture = @embedFile("assets/A.png");
const bTexture = @embedFile("assets/B.png");
const cTexture = @embedFile("assets/C.png");
const circleTexture = @embedFile("assets/Circle.png");

//player
var player: *types.Object = undefined;
var playerSpeed: f32 = 5;
var playerRotSpeed: f32 = 90;

//test block
var testBlock: *types.Object = undefined;

pub fn Start() void {

    //create player
    player = objectHandler.CreateObject();
    player.transform.scale = types.Vec2{ .x = 1, .y = 1 };

    //create test block
    testBlock = objectHandler.CreateObject();
    testBlock.transform.pos = types.Vec2{ .x = 0, .y = -5 };
    testBlock.transform.scale = types.Vec2{ .x = 10, .y = 1 };
    testBlock.transform.layer = -2;

    player.collider.SetCollisionCallback(Test);

    player.graphic.SetAnimationLength(3);
    player.graphic.LoadAnimationFrame(0, &aTexture[0], aTexture.len);
    player.graphic.LoadAnimationFrame(1, &bTexture[0], bTexture.len);
    player.graphic.LoadAnimationFrame(2, &cTexture[0], cTexture.len);
    player.graphic.SetFPS(2);

    //mess around with

    //testBlock.graphic.LoadStaticTexture(&circleTexture[0], circleTexture.len);
    testBlock.graphic.LoadStaticTexture(&bTexture[0], bTexture.len);

    //player.graphic.LoadStaticTexture(&circleTexture[0], circleTexture.len);
    //player.graphic.LoadStaticTexture(&aTexture[0], aTexture.len);

    //testBlock.collider.SetCircleCollision(0.5, types.Vec2{}, true);
    testBlock.collider.SetRectCollision(types.Vec2{ .x = 10, .y = 1 }, types.Vec2{}, true);
    testBlock.physics.static = true;

    //player.collider.SetCircleCollision(0.5, types.Vec2{}, true);
    player.collider.SetRectCollision(types.Vec2{ .x = 1, .y = 1 }, types.Vec2{}, true);
}

pub fn Update() void {
    //move
    var move: types.Vec2 = types.Vec2{};
    if (input.GetKey(input.KEY_W))
        move.y += playerSpeed * time.DeltaTime();
    if (input.GetKey(input.KEY_A))
        move.x -= playerSpeed * time.DeltaTime();
    if (input.GetKey(input.KEY_S))
        move.y -= playerSpeed * time.DeltaTime();
    if (input.GetKey(input.KEY_D))
        move.x += playerSpeed * time.DeltaTime();

    player.transform.pos.x += (player.transform.up().x * move.y) + (player.transform.right().x * move.x);
    player.transform.pos.y += (player.transform.up().y * move.y) + (player.transform.right().y * move.x);

    if (input.GetKey(input.KEY_R))
        player.graphic.PlayAnimation();
    if (input.GetKey(input.KEY_T))
        player.graphic.PauseAnimation();
}

fn Test(other: *types.Object) void {
    _ = other;
}

pub fn Stop() void {
    //do stuff
}
