const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    // Chipmunk C-Code als statische Bibliothek einbinden
    const chipmunk = b.addStaticLibrary(.{
        .name = "chipmunk",
        .optimize = optimize,
        .target = target,
    });
    chipmunk.linkLibC();
    chipmunk.addIncludePath(b.path("lib/chipmunk2d/include"));
    chipmunk.addCSourceFile(.{
        .file = b.path("lib/chipmunk2d/src/chipmunklib.c"),
        .flags = &.{
            "-std=c99",
        },
    });

    // Zchip2D-Modul bereitstellen
    const zchip2d_module = b.addModule("root", .{
        .root_source_file = b.path("src/zchip2d.zig"),
    });

    // Bindings benötigen C-Library
    zchip2d_module.linkLibrary(chipmunk);
}
