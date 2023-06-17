const std = @import("std");

const window = @import("Engine/window.zig");
const time = @import("Engine/time.zig");
const physics = @import("Engine/physics.zig");

const settings = @import("settings.zig");
const program = @import("Game/gameMain.zig");

pub fn main() !void {
    //start
    window.Start(settings.WindowName, settings.DefaultWidth, settings.DefaultHeight);
    program.Start();

    //update
    while (!window.ShouldClose()) {

        //check if less than 5 fps, could have been holding frame
        if (time.DeltaTime() > 0.15)
            time.Calibrate(time.DeltaTime());

        program.Update();
        physics.Update();
        time.Update();
        window.Update();
    }

    //stop
    program.Stop();
    window.Stop();
}
