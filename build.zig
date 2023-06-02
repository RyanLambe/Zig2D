const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const exe = b.addExecutable(.{
        .name = "TestGameThing",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    exe.addIncludePath("./include");
    exe.addIncludePath("/usr/include");
    switch (builtin.target.os.tag) {
        .windows => {
            exe.addLibraryPath("./lib/win_x86_64");
        },
        .linux => {
            exe.addLibraryPath("./lib/linux_x86_64");
            exe.addLibraryPath("/usr/lib");
        },
        else => {},
    }
    exe.linkLibC();
    exe.addCSourceFile("include/glad/glad_gl.c", &[_][]const u8{});
    exe.addCSourceFile("include/LodePng/lodepng.c", &[_][]const u8{});
    switch (builtin.target.os.tag) {
        .windows => {
            exe.linkSystemLibrary("gdi32");
        },
        .linux => {
            exe.linkSystemLibrary("X11");
        },
        else => {},
    }
    exe.linkSystemLibrary("glfw3");
    b.installArtifact(exe);
}
