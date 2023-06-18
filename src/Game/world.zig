const types = @import("../Engine/types.zig");
const objectHandler = @import("../Engine/objectHandler.zig");

var world: [8]*types.Object = undefined;

var worldColour: types.Colour = types.Colour{ .r = 0.675, .g = 0.772, .b = 0.772 };

pub fn Build() void {
    //floor
    world[0] = objectHandler.CreateObject();
    world[0].transform.pos = types.Vec2{ .x = -4, .y = -2 };
    world[0].transform.scale = types.Vec2{ .x = 2, .y = 4 };
    world[0].collider.SetRectCollision(world[0].transform.scale, types.Vec2{}, true);
    world[0].physics.static = true;
    world[0].graphic.colour = worldColour;

    world[1] = objectHandler.CreateObject();
    world[1].transform.pos = types.Vec2{ .x = 0, .y = -2.5 };
    world[1].transform.scale = types.Vec2{ .x = 6, .y = 2 };
    world[1].collider.SetRectCollision(world[1].transform.scale, types.Vec2{}, true);
    world[1].physics.static = true;
    world[1].graphic.colour = worldColour;

    world[2] = objectHandler.CreateObject();
    world[2].transform.pos = types.Vec2{ .x = 4, .y = -2 };
    world[2].transform.scale = types.Vec2{ .x = 2, .y = 4 };
    world[2].collider.SetRectCollision(world[2].transform.scale, types.Vec2{}, true);
    world[2].physics.static = true;
    world[2].graphic.colour = worldColour;

    world[3] = objectHandler.CreateObject();
    world[3].transform.pos = types.Vec2{ .x = 8, .y = -2.5 };
    world[3].transform.scale = types.Vec2{ .x = 6, .y = 2 };
    world[3].collider.SetRectCollision(world[3].transform.scale, types.Vec2{}, true);
    world[3].physics.static = true;
    world[3].graphic.colour = worldColour;

    world[4] = objectHandler.CreateObject();
    world[4].transform.pos = types.Vec2{ .x = 12, .y = -2 };
    world[4].transform.scale = types.Vec2{ .x = 2, .y = 4 };
    world[4].collider.SetRectCollision(world[4].transform.scale, types.Vec2{}, true);
    world[4].physics.static = true;
    world[4].graphic.colour = worldColour;

    //floating platforms
    world[5] = objectHandler.CreateObject();
    world[5].transform.pos = types.Vec2{ .x = 0, .y = 1 };
    world[5].transform.scale = types.Vec2{ .x = 2.5, .y = 0.5 };
    world[5].collider.SetRectCollision(world[5].transform.scale, types.Vec2{}, true);
    world[5].physics.static = true;
    world[5].graphic.colour = worldColour;

    world[6] = objectHandler.CreateObject();
    world[6].transform.pos = types.Vec2{ .x = 4, .y = 3 };
    world[6].transform.scale = types.Vec2{ .x = 2.5, .y = 0.5 };
    world[6].collider.SetRectCollision(world[6].transform.scale, types.Vec2{}, true);
    world[6].physics.static = true;
    world[6].graphic.colour = worldColour;

    world[7] = objectHandler.CreateObject();
    world[7].transform.pos = types.Vec2{ .x = 8, .y = 1 };
    world[7].transform.scale = types.Vec2{ .x = 2.5, .y = 0.5 };
    world[7].collider.SetRectCollision(world[7].transform.scale, types.Vec2{}, true);
    world[7].physics.static = true;
    world[7].graphic.colour = worldColour;
}
