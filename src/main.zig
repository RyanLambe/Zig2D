const std = @import("std");

const window = @import("Engine/window.zig");
const program = @import("Game/gameMain.zig");
const time = @import("Engine/time.zig");
const physics = @import("Engine/physics.zig");

pub fn main() !void {
    //start
    window.Start("Game", 1280, 720);
    program.Start();

    //update
    while (!window.ShouldClose()) {
        
        //check if less than 5 fps, could have been holding frame
        if(time.DeltaTime() > 0.2)
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
