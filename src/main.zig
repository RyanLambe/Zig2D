const window = @import("Engine/window.zig");
const program = @import("Game/gameMain.zig");
const time = @import("Engine/time.zig");

pub fn main() !void {

    //start
    window.Start("Game", 640, 480);
    time.Start();
    program.Start();

    //update
    while (!window.ShouldClose()) {
        program.Update();
        time.Update();
        window.Update();
    }

    //stop
    program.Stop();
    window.Stop();
}
