const std = @import("std");
const c = @import("../Engine/c.zig").c;
const window = @import("../Engine/window.zig");
const objectHandler = @import("../Engine/objectHandler.zig");
const types = @import("../Engine/types.zig");
const time = @import("../Engine/time.zig");

const aTexture = @embedFile("assets/A.png");
const bTexture = @embedFile("assets/B.png");
const cTexture = @embedFile("assets/C.png");

//player
var player: *types.Object = undefined;
var playerSpeed: f32 = 5;
var playerRotSpeed: f32 = 2;

//test block
var testBlock: *types.Object = undefined;

pub fn Start() void {

    //create player
    player = objectHandler.CreateObject();
    player.scale = types.Vec2{ .x = 1, .y = 1 };

    //create test block
    testBlock = objectHandler.CreateObject();
    testBlock.pos = types.Vec2{ .x = 1, .y = 1 };
    testBlock.layer = -2;
    testBlock.colour = types.Colour{
        .r = 1,
        .g = 0.5,
        .b = 0.2,
    };

    player.OnCollisionCallback = Test;

    player.graphic.SetAnimationLength(3);
    player.graphic.LoadAnimationFrame(0, &aTexture[0], aTexture.len);
    player.graphic.LoadAnimationFrame(1, &bTexture[0], bTexture.len);
    player.graphic.LoadAnimationFrame(2, &cTexture[0], cTexture.len);
    player.graphic.SetFPS(2);
}

pub fn Update() void {
    //move
    var move: types.Vec2 = types.Vec2{};
    if (c.glfwGetKey(window.window, c.GLFW_KEY_W) == c.GLFW_PRESS)
        move.y += playerSpeed * time.DeltaTime();
    if (c.glfwGetKey(window.window, c.GLFW_KEY_A) == c.GLFW_PRESS)
        move.x -= playerSpeed * time.DeltaTime();
    if (c.glfwGetKey(window.window, c.GLFW_KEY_S) == c.GLFW_PRESS)
        move.y -= playerSpeed * time.DeltaTime();
    if (c.glfwGetKey(window.window, c.GLFW_KEY_D) == c.GLFW_PRESS)
        move.x += playerSpeed * time.DeltaTime();

    player.pos.x += (player.up().x * move.y) + (player.right().x * move.x);
    player.pos.y += (player.up().y * move.y) + (player.right().y * move.x);

    //rotation
    if (c.glfwGetKey(window.window, c.GLFW_KEY_Q) == c.GLFW_PRESS)
        player.rot -= playerRotSpeed;
    if (c.glfwGetKey(window.window, c.GLFW_KEY_E) == c.GLFW_PRESS)
        player.rot += playerRotSpeed;

    if (c.glfwGetKey(window.window, c.GLFW_KEY_R) == c.GLFW_PRESS)
        player.graphic.StartAnimation();
}

fn Test(other: *types.Object) void {
    _ = other;
    std.debug.print("Hello from test\n", .{});
}

pub fn Stop() void {
    //do stuff
}
