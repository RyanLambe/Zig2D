const std = @import("std");
const c = @import("c.zig").c;

const shaders = @import("shaders.zig");
const time = @import("time.zig");

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

    pub fn Length(vec: Vec2) f32 {
        return std.math.sqrt(vec.x * vec.x + vec.y * vec.y);
    }

    pub fn Normalize(vec: Vec2) Vec2 {
        var length = std.math.sqrt(vec.x * vec.x + vec.y * vec.y);
        if (length == 0)
            return Vec2{};
        return Vec2{ .x = vec.x / length, .y = vec.y / length };
    }

    pub fn Dot(this: Vec2, other: Vec2) f32 {
        return this.x * other.x + this.y * other.y;
    }

    pub fn Add(this: Vec2, other: Vec2) Vec2 {
        return Vec2{ .x = this.x + other.x, .y = this.y + other.y };
    }

    pub fn AddX(this: Vec2, x: f32) Vec2 {
        return Vec2{ .x = this.x + x, .y = this.y + x };
    }

    pub fn AddXY(this: Vec2, x: f32, y: f32) Vec2 {
        return Vec2{ .x = this.x + x, .y = this.y + y };
    }

    pub fn Sub(this: Vec2, other: Vec2) Vec2 {
        return Vec2{ .x = this.x - other.x, .y = this.y - other.y };
    }

    pub fn SubX(this: Vec2, x: f32) Vec2 {
        return Vec2{ .x = this.x - x, .y = this.y - x };
    }

    pub fn SubXY(this: Vec2, x: f32, y: f32) Vec2 {
        return Vec2{ .x = this.x - x, .y = this.y - y };
    }

    pub fn Mul(this: Vec2, other: Vec2) Vec2 {
        return Vec2{ .x = this.x * other.x, .y = this.y * other.y };
    }

    pub fn MulX(this: Vec2, x: f32) Vec2 {
        return Vec2{ .x = this.x * x, .y = this.y * x };
    }

    pub fn MulXY(this: Vec2, x: f32, y: f32) Vec2 {
        return Vec2{ .x = this.x * x, .y = this.y * y };
    }

    pub fn Div(this: Vec2, other: Vec2) Vec2 {
        return Vec2{ .x = this.x / other.x, .y = this.y / other.y };
    }

    pub fn DivX(this: Vec2, x: f32) Vec2 {
        return Vec2{ .x = this.x / x, .y = this.y / x };
    }

    pub fn DivXY(this: Vec2, x: f32, y: f32) Vec2 {
        return Vec2{ .x = this.x / x, .y = this.y / y };
    }
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
    transform: Transform = Transform{},
    graphic: Graphic = Graphic{},
    collider: Collider = Collider{},
    physics: Physics = Physics{},

    //should be treated as read only
    physicsType: PhysicsType = PhysicsType.None,
    id: u32,
};

pub const Transform = struct {
    pos: Vec2 = Vec2{},
    rot: f32 = 0,
    scale: Vec2 = Vec2{ .x = 1, .y = 1 },
    layer: i8 = 0, //-128 to 127

    pub fn up(this: @This()) Vec2 {
        var out: Vec2 = Vec2{};
        var rrot: f32 = (this.rot) * std.math.pi / 180.0;

        out.x = std.math.sin(rrot);
        out.y = std.math.cos(rrot);

        return out;
    }

    pub fn right(this: *@This()) Vec2 {
        var out: Vec2 = Vec2{};
        var rrot: f32 = (this.rot) * std.math.pi / 180.0;

        out.x = std.math.cos(rrot);
        out.y = -std.math.sin(rrot);

        return out;
    }
};

pub const Graphic = struct {
    colour: Colour = Colour{},

    //should be treated as read only
    textures: []c_uint = undefined,
    fps: i32 = 12,
    startFrame: i32 = 0,
    curentFrame: i32 = -1,
    playing: bool = false,
    currentTexture: usize = undefined,

    pub fn LoadStaticTexture(this: *@This(), imageData: *const u8, imageLength: c_ulonglong) void {
        this.SetAnimationLength(1);
        this.textures[0] = LoadTexture(imageData, imageLength);
        this.currentTexture = 0;
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

        if (frame == 0) {
            this.currentTexture = 0;
        }
    }

    pub fn PlayAnimation(this: *@This()) void {
        this.startFrame = time.GetFrame(this.fps);
        this.playing = true;
    }

    pub fn PauseAnimation(this: *@This()) void {
        this.playing = false;
    }

    pub fn SetFPS(this: *@This(), fps: i32) void {
        this.fps = fps;
        this.startFrame = 0;
        this.curentFrame = -1;
    }

    pub fn PrepTexture(this: *@This()) void {

        //check if should be texture
        var location: c_int = c.glGetUniformLocation(shaders.program, "useTexture");
        if (this.textures.len > 0) {
            if (time.GetFrame(this.fps) == this.curentFrame or (!this.playing)) {
                c.glBindTexture(c.GL_TEXTURE_2D, this.textures[this.currentTexture]);
            } else {
                var frame = @mod(@intCast(usize, time.GetFrame(this.fps) - this.startFrame), this.textures.len);
                c.glBindTexture(c.GL_TEXTURE_2D, this.textures[frame]);

                this.curentFrame = time.GetFrame(this.fps);
                this.currentTexture = frame;
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

pub const Collider = struct {
    object: *Object = undefined,

    circleCollider: bool = false,
    colliderOffset: Vec2 = Vec2{},
    colliderScale: ColliderScale = ColliderScale{ .rect = Vec2{ .x = 1, .y = 1 } },
    OnCollisionCallback: *const fn (other: *Object) void = undefined,
    CollisionCallbackEnabled: bool = false,

    pub fn SetRectCollision(this: *@This(), rectScale: Vec2, rectOffset: Vec2, enablePhysics: bool) void {
        this.circleCollider = false;
        this.colliderScale = ColliderScale{ .rect = rectScale };
        this.colliderOffset = rectOffset;
        if (enablePhysics) {
            this.object.physicsType = PhysicsType.PhysicsEnabled;
        } else {
            this.object.physicsType = PhysicsType.CollisionsOnly;
        }
    }

    pub fn SetCircleCollision(this: *@This(), circleRadius: f32, circleOffset: Vec2, enablePhysics: bool) void {
        this.circleCollider = true;
        this.colliderScale = ColliderScale{ .circle = circleRadius };
        this.colliderOffset = circleOffset;
        if (enablePhysics) {
            this.object.physicsType = PhysicsType.PhysicsEnabled;
        } else {
            this.object.physicsType = PhysicsType.CollisionsOnly;
        }
    }

    pub fn RemoveCollision(this: *@This()) void {
        this.colliderScale = ColliderScale{ .rect = Vec2{ .x = 1, .y = 1 } };
        this.colliderOffset = Vec2{};
        this.object.physicsType = PhysicsType.None;
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

pub const Physics = struct {
    object: *Object = undefined,

    static: bool = false,
    mass: f32 = 1,
    elasticity: f32 = 1.75,

    velocity: Vec2 = Vec2{},
    acceleration: Vec2 = Vec2{ .x = 0, .y = -1 },

    staticFriction: f32 = 10,
    dynamicFriction: f32 = 10,

    pub fn ApplyImpulse(this: *@This(), amount: Vec2) void {
        this.velocity.x += amount.x;
        this.velocity.y += amount.y;
    }
};
