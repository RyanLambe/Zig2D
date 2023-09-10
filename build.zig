const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.build.Builder) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const exe = b.addExecutable(.{
        .name = "Zig2D",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    exe.addIncludePath(.{ .path = "./OpenGL" });
    exe.addIncludePath(.{ .path = "/usr/OpenGL" });
    switch (builtin.target.os.tag) {
        .windows => {
            exe.addLibraryPath(.{ .path = "./OpenGL/GLFW/win_x86_64" });
        },
        .linux => {
            exe.addLibraryPath(.{ .path = "./OpenGL/GLFW/linux_x86_64" });
            exe.addLibraryPath(.{ .path = "/usr/lib" });
        },
        else => {},
    }
    exe.linkLibC();
    exe.addCSourceFile(.{ .file = .{ .path = "OpenGL/glad/glad_gl.c" }, .flags = &.{} });
    exe.addCSourceFile(.{ .file = .{ .path = "OpenGL/LodePng/lodepng.c" }, .flags = &.{} });
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
