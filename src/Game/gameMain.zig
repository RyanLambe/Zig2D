const world = @import("world.zig");
const player = @import("playerController.zig");
const camera = @import("cameraController.zig");

pub fn Start() void {
    //is called at the start of the game

    world.Build();
    var setPlayer = player.Start();
    camera.Start(setPlayer);
}

pub fn Update() void {
    //is called once per frame

    player.Update();
    camera.Update();
}

pub fn Stop() void {
    //is called when the game closes
}
