const std = @import("std");
const c = @import("c.zig").c;

const shaders = @import("shaders.zig");
const time = @import("time.zig");

const PI: f32 = 3.14159;

pub var arena: std.heap.ArenaAllocator = undefined;
pub var allocator: std.mem.Allocator = undefined;

pub const Colour = struct {
    r: f32 = 1,
    g: f32 = 1,
    b: f32 = 1,
    a: f32 = 1,
};

pub const Vec2 = struct {
    x: f32 = 0,
    y: f32 = 0,
};

pub const ColliderScale = union {
    rect: Vec2,
    circle: f32,
};

pub const PhysicsType = enum {
    None,
    CollisionsOnly,
    PhysicsEnabled,
};

pub const Object = struct {
    id: u32,

    //transformation
    pos: Vec2 = Vec2{},
    rot: f32 = 0,
    scale: Vec2 = Vec2{ .x = 1, .y = 1 },
    layer: i8 = 0, //-128 to 127

    //colours
    colour: Colour = Colour{},
    graphic: Graphic = Graphic{},

    //collider
    circleCollider: bool = false,
    colliderOffset: Vec2 = Vec2{},
    colliderScale: ColliderScale = ColliderScale{ .rect = Vec2{ .x = 1, .y = 1 } },
    OnCollisionCallback: *const fn (other: *Object) void = undefined,
    CollisionCallbackEnabled: bool = false,

    //physics
    physicsType: PhysicsType = PhysicsType.None,
    //???

    pub fn up(this: @This()) Vec2 {
        var out: Vec2 = Vec2{};
        var rrot: f32 = (this.rot) * PI / 180.0;

        out.x = std.math.sin(rrot);
        out.y = std.math.cos(rrot);

        return out;
    }

    pub fn right(this: *@This()) Vec2 {
        var out: Vec2 = Vec2{};
        var rrot: f32 = (this.rot) * PI / 180.0;

        out.x = std.math.cos(rrot);
        out.y = -std.math.sin(rrot);

        return out;
    }

    pub fn SetRectCollision(this: *@This(), rectScale: Vec2, rectOffset: Vec2, enablePhysics: bool) void {
        this.circleCollider = false;
        this.colliderScale = ColliderScale{ .rect = rectScale };
        this.colliderOffset = rectOffset;
        if (enablePhysics) {
            this.physicsType = PhysicsType.PhysicsEnabled;
        } else {
            this.physicsType = PhysicsType.CollisionsOnly;
        }
    }

    pub fn SetCircleCollision(this: *@This(), circleRadius: f32, circleOffset: Vec2, enablePhysics: bool) void {
        this.circleCollider = true;
        this.colliderScale = ColliderScale{ .circle = circleRadius };
        this.colliderOffset = circleOffset;
        if (enablePhysics) {
            this.physicsType = PhysicsType.PhysicsEnabled;
        } else {
            this.physicsType = PhysicsType.CollisionsOnly;
        }
    }

    pub fn RemoveCollision(this: *@This()) void {
        this.colliderScale = ColliderScale{ .rect = Vec2{ .x = 1, .y = 1 } };
        this.colliderOffset = Vec2{};
        this.physicsType = PhysicsType.None;
    }

    pub fn SetCollisionCallback(this: *@This(), callback: *const fn (other: *Object) void) void {
        this.OnCollisionCallback = callback;
        this.CollisionCallbackEnabled = true;
    }

    pub fn RemoveCollisionCallback(this: *@This()) void {
        this.OnCollisionCallback = undefined;
        this.CollisionCallbackEnabled = false;
    }

    pub fn CollisionCallback(this: *@This(), other: *Object) void {
        if (this.CollisionCallbackEnabled)
            this.OnCollisionCallback(other);
    }
};

pub const Graphic = struct {
    textures: []c_uint = undefined,
    fps: i32 = 12,
    startFrame: i32 = 0,
    curentFrame: i32 = -1,
    currentTexture: c_uint = undefined,

    pub fn LoadStaticTexture(this: *@This(), imageData: *const u8, imageLength: c_ulonglong) void {
        this.SetAnimationLength(1);
        this.textures[0] = LoadTexture(imageData, imageLength);
    }

    pub fn SetAnimationLength(this: *@This(), frameCount: usize) void {
        this.textures = allocator.alloc(c_uint, frameCount) catch {
            std.debug.print("could not create texture array.\n", .{});
            return undefined;
        };
    }

    pub fn LoadAnimationFrame(this: *@This(), frame: usize, imageData: *const u8, imageLength: c_ulonglong) void {
        if (frame >= this.textures.len) {
            std.debug.print("cannot load texture, frame out of bounds. Make sure to use SetAnimationLength before setting the frames.\n", .{});
            return;
        }

        this.textures[frame] = LoadTexture(imageData, imageLength);
    }

    pub fn StartAnimation(this: *@This()) void {
        this.startFrame = time.GetFrame(this.fps) + 1;
    }

    pub fn SetFPS(this: *@This(), fps: i32) void {
        this.fps = fps;
        this.startFrame = 0;
        this.curentFrame = -1;
    }

    pub fn PrepTexture(this: *@This()) void {
        var location: c_int = c.glGetUniformLocation(shaders.program, "useTexture");
        if (this.textures.len > 0) {
            if (time.GetFrame(this.fps) == this.curentFrame) {
                c.glBindTexture(c.GL_TEXTURE_2D, this.currentTexture);
            } else {
                var frame = @mod(@intCast(usize, time.GetFrame(this.fps) - this.startFrame), this.textures.len);
                c.glBindTexture(c.GL_TEXTURE_2D, this.textures[frame]);

                this.curentFrame = time.GetFrame(this.fps);
                this.currentTexture = this.textures[frame];
            }

            c.glUniform1i(location, 1);
        } else {
            c.glUniform1i(location, 0);
        }
    }
};

fn LoadTexture(imageData: *const u8, imageLength: c_ulonglong) c_uint {
    var id: c_uint = undefined;

    c.glGenTextures(1, &id);
    c.glBindTexture(c.GL_TEXTURE_2D, id);

    c.glTexParameteri(c.GL_TEXTURE_2D, c.GL_TEXTURE_WRAP_S, c.GL_REPEAT);
    c.glTexParameteri(c.GL_TEXTURE_2D, c.GL_TEXTURE_WRAP_T, c.GL_REPEAT);
    c.glTexParameteri(c.GL_TEXTURE_2D, c.GL_TEXTURE_MIN_FILTER, c.GL_LINEAR);
    c.glTexParameteri(c.GL_TEXTURE_2D, c.GL_TEXTURE_MAG_FILTER, c.GL_LINEAR);

    var data: [*c]u8 = undefined;
    var width: c_uint = undefined;
    var height: c_uint = undefined;
    var err = c.lodepng_decode_memory(&data, &width, &height, imageData, imageLength, 6, 8);

    if (err != 1) {
        c.glTexImage2D(c.GL_TEXTURE_2D, 0, c.GL_RGBA, @intCast(c_int, width), @intCast(c_int, height), 0, c.GL_RGBA, c.GL_UNSIGNED_BYTE, data);
        c.glGenerateMipmap(c.GL_TEXTURE_2D);
        return id;
    } else {
        std.debug.print("Failed to load texture.\n", .{});
        return 0;
    }
}
