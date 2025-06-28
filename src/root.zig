//! bf - Advanced Physics Engine
//!
//! A high-performance physics engine written in Zig.
//! This is the main library entry point.
//!
//! Usage:
//!   const bf = @import("bf");
//!   const world = bf.World.init(allocator);
//!   const body = world.addRigidBody(.{ .position = bf.math.Vec2.init(0, 0) });

const std = @import("std");
const testing = std.testing;

// Re-export all bf modules
pub const math = @import("math/math.zig");

// TODO: Add these modules as we implement them
// pub const collision = @import("collision/collision.zig");
// pub const dynamics = @import("dynamics/dynamics.zig");
// pub const world = @import("world/world.zig");

// Legacy function for testing build system
pub export fn add(a: i32, b: i32) i32 {
    return a + b;
}

// Test that the module structure works
test "bf module structure" {
    // Test that we can access math types through the main module
    const pos = math.Vec2.init(1.0, 2.0);
    const vel = math.Vec2.init(0.5, -1.0);
    const result = pos.add(vel);

    try testing.expectEqual(@as(f32, 1.5), result.x);
    try testing.expectEqual(@as(f32, 1.0), result.y);
}

test "basic add functionality" {
    try testing.expect(add(3, 7) == 10);
}
