const window = @import("Engine/window.zig");
const program = @import("Game/gameMain.zig");
const time = @import("Engine/time.zig");
const physics = @import("Engine/physics.zig");

pub fn main() !void {

    //start
    window.Start("Game", 640, 480);
    time.Start();
    program.Start();

    //update
    while (!window.ShouldClose()) {
        program.Update();
        physics.Update();
        time.Update();
        window.Update();
    }

    //stop
    program.Stop();
    window.Stop();
}
