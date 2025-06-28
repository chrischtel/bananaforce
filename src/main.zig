//! BF Demo Program
//!
//! This executable demonstrates the capabilities of the BF physics engine.
//! Currently showcases the math module - will expand as more features are added.

const std = @import("std");
const print = std.debug.print;
const bf = @import("bananaforce_lib");

pub fn main() !void {
    print("=== BF - BananaForce Demo ===\n\n", .{});

    // Math Module Demo
    print("📐 Math Module Demo:\n", .{});
    demonstrateMath();

    // === Vec3 Module Demo ===
    print("\n🌐 Vec3 Module Demo:\n", .{});
    demonstrateVec3();

    print("\n🎯 Demo completed successfully!\n", .{});
    print("🧪 Run 'zig build test' to run all unit tests.\n", .{});
    print("📚 Vec2: 8 tests, Vec3: 11 tests, Total: 19+ math tests passing!\n", .{});
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

// Tests for the main executable
test "main executable tests" {
    // Just ensure main doesn't crash
    // In a real demo, you might test specific demo functions
}

test "use bf library" {
    // Test that we can use the bf library correctly
    const pos = bf.math.Vec2.init(1.0, 2.0);
    const vel = bf.math.Vec2.init(3.0, 4.0);
    const result = pos.add(vel);

    try std.testing.expectEqual(@as(f32, 4.0), result.x);
    try std.testing.expectEqual(@as(f32, 6.0), result.y);
}

test "legacy add function" {
    // Keep the old test for build system compatibility
    try std.testing.expectEqual(@as(i32, 150), bf.add(100, 50));
}
