const std = @import("std");

pub const Vec3 = struct {
    x: f32,
    y: f32,
    z: f32,

    pub fn init(x: f32, y: f32, z: f32) Vec3 {
        return Vec3{ .x = x, .y = y, .z = z };
    }

    pub fn add(self: Vec3, other: Vec3) Vec3 {
        return Vec3{ .x = self.x + other.x, .y = self.y + other.y, .z = self.z + other.z };
    }

    pub fn sub(self: Vec3, other: Vec3) Vec3 {
        return Vec3{ .x = self.x - other.x, .y = self.y - other.y, .z = self.z - other.z };
    }

    pub fn mul(self: Vec3, scalar: f32) Vec3 {
        return Vec3{ .x = self.x * scalar, .y = self.y * scalar, .z = self.z * scalar };
    }

    pub fn div(self: Vec3, scalar: f32) Vec3 {
        // Handle division by zero by returning zero vector
        if (scalar == 0.0) {
            return Vec3{ .x = 0.0, .y = 0.0, .z = 0.0 };
        }
        return Vec3{ .x = self.x / scalar, .y = self.y / scalar, .z = self.z / scalar };
    }

    pub fn cross(self: Vec3, other: Vec3) Vec3 {
        return Vec3{
            .x = self.y * other.z - self.z * other.y,
            .y = self.z * other.x - self.x * other.z,
            .z = self.x * other.y - self.y * other.x,
        };
    }

    pub fn lengthSquared(self: Vec3) f32 {
        return self.x * self.x + self.y * self.y + self.z * self.z;
    }

    pub fn length(self: Vec3) f32 {
        return @sqrt(self.lengthSquared());
    }

    pub fn normalize(self: Vec3) Vec3 {
        const len = self.length();
        if (len < 0.0001) { // Avoid division by very small numbers
            return Vec3{ .x = 0.0, .y = 0.0, .z = 0.0 };
        }
        return self.div(len);
    }

    pub fn dot(self: Vec3, other: Vec3) f32 {
        return self.x * other.x + self.y * other.y + self.z * other.z;
    }

    // Common constants
    pub const ZERO = Vec3{ .x = 0.0, .y = 0.0, .z = 0.0 };
    pub const ONE = Vec3{ .x = 1.0, .y = 1.0, .z = 1.0 };
    pub const UNIT_X = Vec3{ .x = 1.0, .y = 0.0, .z = 0.0 };
    pub const UNIT_Y = Vec3{ .x = 0.0, .y = 1.0, .z = 0.0 };
    pub const UNIT_Z = Vec3{ .x = 0.0, .y = 0.0, .z = 1.0 };
    pub const UP = UNIT_Y;
    pub const DOWN = Vec3{ .x = 0.0, .y = -1.0, .z = 0.0 };
    pub const RIGHT = UNIT_X;
    pub const LEFT = Vec3{ .x = -1.0, .y = 0.0, .z = 0.0 };
    pub const FORWARD = Vec3{ .x = 0.0, .y = 0.0, .z = -1.0 };
    pub const BACK = UNIT_Z;
};

const testing = std.testing;
const expectEqual = testing.expectEqual;
const expectApproxEqRel = testing.expectApproxEqRel;

test "Vec3 initialization" {
    const vec = Vec3.init(1.0, 2.0, 3.0);
    try expectEqual(vec.x, 1.0);
    try expectEqual(vec.y, 2.0);
    try expectEqual(vec.z, 3.0);
}

test "Vec3 addition" {
    const vec1 = Vec3.init(1.0, 2.0, 3.0);
    const vec2 = Vec3.init(4.0, 5.0, 6.0);
    const result = vec1.add(vec2);
    try expectEqual(result.x, 5.0);
    try expectEqual(result.y, 7.0);
    try expectEqual(result.z, 9.0);
}

test "Vec3 subtraction" {
    const vec1 = Vec3.init(4.0, 5.0, 6.0);
    const vec2 = Vec3.init(1.0, 2.0, 3.0);
    const result = vec1.sub(vec2);
    try expectEqual(result.x, 3.0);
    try expectEqual(result.y, 3.0);
    try expectEqual(result.z, 3.0);
}

test "Vec3 multiplication" {
    const vec = Vec3.init(1.0, 2.0, 3.0);
    const result = vec.mul(2.0);
    try expectEqual(result.x, 2.0);
    try expectEqual(result.y, 4.0);
    try expectEqual(result.z, 6.0);
}

test "Vec3 division" {
    const vec = Vec3.init(1.0, 2.0, 3.0);
    const result = vec.div(2.0);
    try expectEqual(result.x, 0.5);
    try expectEqual(result.y, 1.0);
    try expectEqual(result.z, 1.5);
}

test "Vec3 division by zero" {
    const vec = Vec3.init(1.0, 2.0, 3.0);
    const result = vec.div(0.0);
    try expectEqual(result.x, 0.0);
    try expectEqual(result.y, 0.0);
    try expectEqual(result.z, 0.0);
}

test "Vec3 cross product" {
    const vec1 = Vec3.init(1.0, 2.0, 3.0);
    const vec2 = Vec3.init(4.0, 5.0, 6.0);
    const result = vec1.cross(vec2);
    try expectEqual(result.x, -3.0);
    try expectEqual(result.y, 6.0);
    try expectEqual(result.z, -3.0);
}

test "Vec3 length" {
    const vec = Vec3.init(3.0, 4.0, 0.0);
    try expectEqual(vec.length(), 5.0);

    const vec2 = Vec3.init(1.0, 2.0, 2.0);
    try expectEqual(vec2.lengthSquared(), 9.0);
    try expectEqual(vec2.length(), 3.0);
}

test "Vec3 normalize" {
    const vec = Vec3.init(3.0, 4.0, 0.0);
    const normalized = vec.normalize();
    try expectEqual(normalized.x, 0.6);
    try expectEqual(normalized.y, 0.8);
    try expectEqual(normalized.z, 0.0);
    try expectApproxEqRel(normalized.length(), 1.0, 0.0001);

    // Test zero vector normalization
    const zero = Vec3.ZERO.normalize();
    try expectEqual(zero.x, 0.0);
    try expectEqual(zero.y, 0.0);
    try expectEqual(zero.z, 0.0);
}

test "Vec3 dot product" {
    const vec1 = Vec3.init(1.0, 2.0, 3.0);
    const vec2 = Vec3.init(4.0, 5.0, 6.0);
    const result = vec1.dot(vec2);
    try expectEqual(result, 32.0); // 1*4 + 2*5 + 3*6 = 4 + 10 + 18 = 32

    // Test perpendicular vectors (dot product should be 0)
    const perpResult = Vec3.UNIT_X.dot(Vec3.UNIT_Y);
    try expectEqual(perpResult, 0.0);
}

test "Vec3 constants" {
    try expectEqual(Vec3.ZERO.x, 0.0);
    try expectEqual(Vec3.ZERO.y, 0.0);
    try expectEqual(Vec3.ZERO.z, 0.0);

    try expectEqual(Vec3.ONE.x, 1.0);
    try expectEqual(Vec3.ONE.y, 1.0);
    try expectEqual(Vec3.ONE.z, 1.0);

    try expectEqual(Vec3.UNIT_X.x, 1.0);
    try expectEqual(Vec3.UNIT_X.y, 0.0);
    try expectEqual(Vec3.UNIT_X.z, 0.0);

    try expectEqual(Vec3.UP.y, 1.0);
    try expectEqual(Vec3.DOWN.y, -1.0);
    try expectEqual(Vec3.FORWARD.z, -1.0);
    try expectEqual(Vec3.BACK.z, 1.0);
}
