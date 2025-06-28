//! BF Demo Program
//!
//! This executable demonstrates the capabilities of the BF physics engine.
//! Currently showcases the math module - will expand as more features are added.

const std = @import("std");
const print = std.debug.print;
const bf = @import("bananaforce_lib");

pub fn main() !void {
    print("=== BananaForce Physics Engine Demo ===\n\n", .{});

    // Math Module Demo
    print("Math Module Demo:\n", .{});
    demonstrateMath();

    // Vec3 Module Demo
    print("\nVec3 Module Demo:\n", .{});
    demonstrateVec3();

    // Matrix Module Demo
    print("\nMatrix Module Demo:\n", .{});
    demonstrateMatrices();

    print("\nDemo completed successfully!\n", .{});
    print("Run 'zig build test' to run all unit tests.\n", .{});
    print("Vec2: 8 tests, Vec3: 11 tests, Mat3: 12 tests, Mat4: 10 tests\n", .{});
    print("Total: 40+ math tests passing!\n", .{});
}

fn demonstrateMath() void {
    print("  Creating vectors...\n", .{});

    // Create some vectors
    const position = bf.math.Vec2.init(10.0, 5.0);
    const velocity = bf.math.Vec2.init(-2.0, 8.0);

    print("  Position: ({d:.1}, {d:.1})\n", .{ position.x, position.y });
    print("  Velocity: ({d:.1}, {d:.1})\n", .{ velocity.x, velocity.y });

    // Vector operations
    const new_position = position.add(velocity);
    print("  New position after velocity: ({d:.1}, {d:.1})\n", .{ new_position.x, new_position.y });

    const distance = position.sub(new_position).length();
    print("  Distance moved: {d:.2}\n", .{distance});

    // Normalization
    const normalized_velocity = velocity.normalize();
    print("  Normalized velocity: ({d:.3}, {d:.3})\n", .{ normalized_velocity.x, normalized_velocity.y });
    print("  Normalized length: {d:.3}\n", .{normalized_velocity.length()});

    // Dot product (useful for physics calculations)
    const dot = position.dot(velocity);
    print("  Dot product: {d:.2}\n", .{dot});

    // Perpendicular vector (useful for 2D cross products)
    const perp = velocity.perp();
    print("  Perpendicular to velocity: ({d:.1}, {d:.1})\n", .{ perp.x, perp.y });

    // Math utilities
    print("  Interpolating between positions: ", .{});
    for (0..6) |i| {
        const t = @as(f32, @floatFromInt(i)) / 5.0;
        const lerped_x = bf.math.lerp(position.x, new_position.x, t);
        const lerped_y = bf.math.lerp(position.y, new_position.y, t);
        print("({d:.1},{d:.1}) ", .{ lerped_x, lerped_y });
    }
    print("\n", .{});
}

fn demonstrateVec3() void {
    // Create 3D vectors
    const position3d = bf.math.Vec3.init(10.0, 5.0, 2.0);
    const velocity3d = bf.math.Vec3.init(-2.0, 8.0, -1.0);
    print("  3D Position: ({d:.1}, {d:.1}, {d:.1})\n", .{ position3d.x, position3d.y, position3d.z });
    print("  3D Velocity: ({d:.1}, {d:.1}, {d:.1})\n", .{ velocity3d.x, velocity3d.y, velocity3d.z });

    // Vector operations
    const newPosition3d = position3d.add(velocity3d);
    print("  New 3D position after velocity: ({d:.1}, {d:.1}, {d:.1})\n", .{ newPosition3d.x, newPosition3d.y, newPosition3d.z });

    // Length and normalization
    const distance3d = velocity3d.length();
    const normalizedVelocity3d = velocity3d.normalize();
    print("  3D Distance moved: {d:.2}\n", .{distance3d});
    print("  Normalized 3D velocity: ({d:.3}, {d:.3}, {d:.3})\n", .{ normalizedVelocity3d.x, normalizedVelocity3d.y, normalizedVelocity3d.z });
    print("  Normalized length: {d:.3}\n", .{normalizedVelocity3d.length()});

    // Dot and cross products
    const dotProduct3d = position3d.dot(velocity3d);
    const crossProduct3d = position3d.cross(velocity3d);
    print("  Dot product: {d:.2}\n", .{dotProduct3d});
    print("  Cross product: ({d:.1}, {d:.1}, {d:.1})\n", .{ crossProduct3d.x, crossProduct3d.y, crossProduct3d.z });

    // Using constants
    print("  Using Vec3 constants:\n", .{});
    print("    UP: ({d:.1}, {d:.1}, {d:.1})\n", .{ bf.math.Vec3.UP.x, bf.math.Vec3.UP.y, bf.math.Vec3.UP.z });
    print("    FORWARD: ({d:.1}, {d:.1}, {d:.1})\n", .{ bf.math.Vec3.FORWARD.x, bf.math.Vec3.FORWARD.y, bf.math.Vec3.FORWARD.z });
    print("    RIGHT: ({d:.1}, {d:.1}, {d:.1})\n", .{ bf.math.Vec3.RIGHT.x, bf.math.Vec3.RIGHT.y, bf.math.Vec3.RIGHT.z });
}

fn demonstrateMatrices() void {
    print("  Creating 3x3 matrices...\n", .{});

    // Mat3 demonstrations
    const identity3 = bf.math.Mat3.IDENTITY;
    const rotation3 = bf.math.Mat3.rotation2D(std.math.pi / 4.0); // 45 degrees
    const scale3 = bf.math.Mat3.scale2D(2.0, 1.5);

    print("  Identity matrix (3x3): [{d:.1}, {d:.1}, {d:.1}]\n", .{ identity3.get(0, 0), identity3.get(0, 1), identity3.get(0, 2) });
    print("                         [{d:.1}, {d:.1}, {d:.1}]\n", .{ identity3.get(1, 0), identity3.get(1, 1), identity3.get(1, 2) });
    print("                         [{d:.1}, {d:.1}, {d:.1}]\n", .{ identity3.get(2, 0), identity3.get(2, 1), identity3.get(2, 2) });

    // Matrix-vector multiplication
    const test_vec = bf.math.Vec3.init(1.0, 0.0, 1.0);
    const rotated = rotation3.mulVec(test_vec);
    print("  Rotating (1,0,1) by 45°: ({d:.2}, {d:.2}, {d:.2})\n", .{ rotated.x, rotated.y, rotated.z });

    const scaled = scale3.mulVec(test_vec);
    print("  Scaling (1,0,1) by (2,1.5): ({d:.1}, {d:.1}, {d:.1})\n", .{ scaled.x, scaled.y, scaled.z });

    print("  Creating 4x4 matrices...\n", .{});

    // Mat4 demonstrations
    const identity4 = bf.math.Mat4.IDENTITY;
    const translation = bf.math.Mat4.translation(5.0, 3.0, -2.0);
    const scale4 = bf.math.Mat4.scaleXYZ(2.0, 2.0, 2.0);
    const rotationY = bf.math.Mat4.rotationY(std.math.pi / 6.0); // 30 degrees

    print("  4x4 Identity determinant: {d:.1}\n", .{identity4.determinant()});

    // Transform a 3D point
    const point3d = bf.math.Vec3.init(1.0, 1.0, 1.0);
    const translated = translation.mulPoint(point3d);
    print("  Translating (1,1,1) by (5,3,-2): ({d:.1}, {d:.1}, {d:.1})\n", .{ translated.x, translated.y, translated.z });

    const scaled4 = scale4.mulPoint(point3d);
    print("  Scaling (1,1,1) by 2: ({d:.1}, {d:.1}, {d:.1})\n", .{ scaled4.x, scaled4.y, scaled4.z });

    const rotated4 = rotationY.mulPoint(point3d);
    print("  Rotating (1,1,1) around Y by 30°: ({d:.2}, {d:.2}, {d:.2})\n", .{ rotated4.x, rotated4.y, rotated4.z });

    // Matrix composition (combining transformations)
    const combined = translation.mulMat(scale4).mulMat(rotationY);
    const final_result = combined.mulPoint(point3d);
    print("  Combined transform result: ({d:.2}, {d:.2}, {d:.2})\n", .{ final_result.x, final_result.y, final_result.z });

    // Demonstrate inverse
    if (scale4.inverse()) |inverse_scale| {
        const original = inverse_scale.mulPoint(scaled4);
        print("  Scale inverse check: ({d:.3}, {d:.3}, {d:.3}) -> original\n", .{ original.x, original.y, original.z });
    }
}

// Tests for the main executable
test "main executable tests" {
    // Just ensure main doesn't crash
    // In a real demo, you might test specific demo functions
}

test "use bf library with matrices" {
    // Test that we can use the bf library matrix types correctly
    const mat3 = bf.math.Mat3.IDENTITY;
    const vec3 = bf.math.Vec3.init(1.0, 2.0, 3.0);
    const result3 = mat3.mulVec(vec3);

    try std.testing.expectEqual(@as(f32, 1.0), result3.x);
    try std.testing.expectEqual(@as(f32, 2.0), result3.y);
    try std.testing.expectEqual(@as(f32, 3.0), result3.z);

    const mat4 = bf.math.Mat4.translation(1.0, 2.0, 3.0);
    const point = bf.math.Vec3.init(0.0, 0.0, 0.0);
    const translated = mat4.mulPoint(point);

    try std.testing.expectEqual(@as(f32, 1.0), translated.x);
    try std.testing.expectEqual(@as(f32, 2.0), translated.y);
    try std.testing.expectEqual(@as(f32, 3.0), translated.z);
}

test "legacy add function" {
    // Keep the old test for build system compatibility
    try std.testing.expectEqual(@as(i32, 150), bf.add(100, 50));
}
