# Zig Physics: [zchip2d](https://github.com/deinuser/zchip2d)

Zig build package and bindings for [Chipmunk2D](https://github.com/slembcke/Chipmunk2D) 7.x physics engine.

## Getting started

Download and add zchip2d as a dependency by running the following command in your project root:

```
zig fetch --save git+https://github.com/eisvogelstudio/zchip2d.git
```

Example`build.zig`:

```zig
pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{ ... });

    const zchip2d = b.dependency("zchip2d", .{
        .target = target,
        .optimize = optimize,
    });

    exe.root_module.addImport("zchip2d", zchip2d.module("zchip2d"));
    exe.linkLibrary(zchip2d.artifact("zchip2d"));
}
```

Now in your code you may import and use zchip2d:

```zig
const std = @import("std");
const zchip2d = @import("zchip2d");

pub fn main() void {
    // world
    const space = zchip2d.cpSpaceNew().?;
    zchip2d.cpSpaceSetGravity(space, zchip2d.cpv(0.0, -100.0));

    // ground (static)
    const staticBody = zchip2d.cpSpaceGetStaticBody(space);
    const segment = zchip2d.cpSegmentShapeNew(staticBody, zchip2d.cpv(-300, 0), zchip2d.cpv(300, 0), 0.0);
    zchip2d.cpShapeSetFriction(segment, 1.0);
    _ = zchip2d.cpSpaceAddShape(space, segment);

    // body (dynamic)
    const mass: zchip2d.cpFloat = 1.0;
    const radius: zchip2d.cpFloat = 15.0;
    const moment = zchip2d.cpMomentForCircle(mass, 0.0, radius, zchip2d.cpvzero);

    const body = zchip2d.cpSpaceAddBody(space, zchip2d.cpBodyNew(mass, moment));
    zchip2d.cpBodySetPosition(body, zchip2d.cpv(0.0, 100.0));

    const shape = zchip2d.cpSpaceAddShape(space, zchip2d.cpCircleShapeNew(body, radius, zchip2d.cpvzero));
    zchip2d.cpShapeSetFriction(shape, 0.7);

    // simulation
    var i: u32 = 0;
    while (i < 10) : (i += 1) {
        zchip2d.cpSpaceStep(space, 1.0 / 60.0);
        const pos = zchip2d.cpBodyGetPosition(body);
        std.debug.print("Step {}: x = {}, y = {}\n", .{ i, pos.x, pos.y });
    }

    // cleanup
    zchip2d.cpShapeFree(shape);
    zchip2d.cpBodyFree(body);
    zchip2d.cpShapeFree(segment);
    zchip2d.cpSpaceFree(space);
}
```

## About

This project currently provides basic Zig integration for Chipmunk2D via `@cImport`. It exposes the original C API without abstraction. At this stage, there is no idiomatic Zig wrapper. You work directly with the C functions as defined in `chipmunk/chipmunk.h`. A proper wrapper may follow once the usage patterns justify the effort.
