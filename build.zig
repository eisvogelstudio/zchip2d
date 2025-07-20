const std = @import("std");

pub fn build(b: *std.Build) void {
    const optimize = b.standardOptimizeOption(.{});
    const target = b.standardTargetOptions(.{});

    const chipmunk = b.addStaticLibrary(.{
        .name = "zchip2d",
        .optimize = optimize,
        .target = target,
    });
    chipmunk.linkLibC();
    chipmunk.addIncludePath(b.path("lib/chipmunk2d/include"));

    const chipmunk_sources = &[_][]const u8{
        "chipmunk.c",       "cpArray.c",            "cpCollision.c",
        "cpDampedSpring.c", "cpHashSet.c",          "cpPinJoint.c",
        "cpPolyShape.c",    "cpRotaryLimitJoint.c", "cpSlideJoint.c",
        "cpSpaceDebug.c",   "cpSpaceStep.c",        "cpBBTree.c",
        "cpConstraint.c",   "cpGearJoint.c",        "cpHastySpace.c",
        "cpPivotJoint.c",   "cpRatchetJoint.c",     "cpShape.c",
        "cpSpace.c",        "cpSpaceHash.c",        "cpSpatialIndex.c",
        "cpArbiter.c",      "cpBody.c",             "cpDampedRotarySpring.c",
        "cpGrooveJoint.c",  "cpMarch.c",            "cpPolyline.c",
        "cpRobust.c",       "cpSimpleMotor.c",      "cpSpaceComponent.c",
        "cpSpaceQuery.c",   "cpSweep1D.c",
    };
    for (chipmunk_sources) |src| {
        chipmunk.addCSourceFile(.{
            .file = b.path(std.mem.join(b.allocator, "/", &.{ "lib/chipmunk2d/src", src }) catch unreachable),
            .flags = &.{"-std=c99"},
        });
    }

    const zchip2d_module = b.addModule("zchip2d", .{
        .root_source_file = b.path("src/zchip2d.zig"),
    });
    zchip2d_module.addIncludePath(b.path("lib/chipmunk2d/include"));

    b.installArtifact(chipmunk);
}
