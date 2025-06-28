//! BananaForce Math Module
//!
//! This module provides all mathematical primitives needed for physics simulation:
//! - Vector operations (Vec2, Vec3, Vec4)
//! - Matrix operations (Mat3, Mat4)
//! - Quaternion operations
//! - Common mathematical utilities
//!
//! Usage:
//!   const math = @import("math/math.zig");
//!   const pos = math.Vec2.init(1.0, 2.0);

// Re-export all math types and functions
pub const Vec2 = @import("vec2.zig").Vec2;

pub const Vec3 = @import("vec3.zig").Vec3;
pub const Vec4 = @import("vec4.zig").Vec4;
// pub const Mat3 = @import("mat3.zig").Mat3;
// pub const Mat4 = @import("mat4.zig").Mat4;
// pub const Quaternion = @import("quaternion.zig").Quaternion;

// Common constants
pub const PI = 3.14159265358979323846;
pub const TAU = 2.0 * PI;
pub const DEG_TO_RAD = PI / 180.0;
pub const RAD_TO_DEG = 180.0 / PI;

// Common utility functions
pub fn lerp(a: f32, b: f32, t: f32) f32 {
    return a + (b - a) * t;
}

pub fn clamp(value: f32, min_val: f32, max_val: f32) f32 {
    return @max(min_val, @min(max_val, value));
}

pub fn approximately(a: f32, b: f32, epsilon: f32) bool {
    return @abs(a - b) < epsilon;
}

// Test that our re-exports work
const testing = @import("std").testing;

test "math module re-exports" {
    const v2 = Vec2.init(1.0, 2.0);
    try testing.expectEqual(@as(f32, 1.0), v2.x);
    try testing.expectEqual(@as(f32, 2.0), v2.y);

    const v3 = Vec3.init(1.0, 2.0, 3.0);
    try testing.expectEqual(@as(f32, 1.0), v3.x);
    try testing.expectEqual(@as(f32, 2.0), v3.y);
    try testing.expectEqual(@as(f32, 3.0), v3.z);

    _ = Vec4.init(1.0, 2.0, 3.0, 4.0);
}

test "math utilities" {
    try testing.expectEqual(@as(f32, 1.5), lerp(1.0, 2.0, 0.5));
    try testing.expectEqual(@as(f32, 5.0), clamp(10.0, 0.0, 5.0));
    try testing.expect(approximately(1.0, 1.001, 0.01));
}
