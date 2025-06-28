const std = @import("std");

pub const Vec4 = struct {
    x: f32,
    y: f32,
    z: f32,
    w: f32,

    pub fn init(x: f32, y: f32, z: f32, w: f32) Vec4 {
        return Vec4{ .x = x, .y = y, .z = z, .w = w };
    }

    pub fn add(self: Vec4, other: Vec4) Vec4 {
        return Vec4{ .x = self.x + other.x, .y = self.y + other.y, .z = self.z + other.z, .w = self.w + other.w };
    }

    pub fn sub(self: Vec4, other: Vec4) Vec4 {
        return Vec4{ .x = self.x - other.x, .y = self.y - other.y, .z = self.z - other.z, .w = self.w - other.w };
    }

    pub fn mul(self: Vec4, scalar: f32) Vec4 {
        return Vec4{ .x = self.x * scalar, .y = self.y * scalar, .z = self.z * scalar, .w = self.w * scalar };
    }

    pub fn div(self: Vec4, scalar: f32) Vec4 {
        // Handle division by zero by returning zero vector
        if (scalar == 0.0) {
            return Vec4{ .x = 0.0, .y = 0.0, .z = 0.0, .w = 0.0 };
        }
        return Vec4{ .x = self.x / scalar, .y = self.y / scalar, .z = self.z / scalar, .w = self.w / scalar };
    }

    pub fn dot(self: Vec4, other: Vec4) f32 {
        return self.x * other.x + self.y * other.y + self.z * other.z + self.w * other.w;
    }

    pub fn lengthSquared(self: Vec4) f32 {
        return self.x * self.x + self.y * self.y + self.z * self.z + self.w * self.w;
    }

    pub fn length(self: Vec4) f32 {
        return @sqrt(self.lengthSquared());
    }

    pub fn normalize(self: Vec4) Vec4 {
        const len = self.length();
        if (len < 0.0001) { // Avoid division by very small numbers
            return Vec4{ .x = 0.0, .y = 0.0, .z = 0.0, .w = 0.0 };
        }
        return self.div(len);
    }

    // Component-wise multiplication (hadamard product)
    pub fn mulVec(self: Vec4, other: Vec4) Vec4 {
        return Vec4{ .x = self.x * other.x, .y = self.y * other.y, .z = self.z * other.z, .w = self.w * other.w };
    }

    // Common constants
    pub const ZERO = Vec4{ .x = 0.0, .y = 0.0, .z = 0.0, .w = 0.0 };
    pub const ONE = Vec4{ .x = 1.0, .y = 1.0, .z = 1.0, .w = 1.0 };
    pub const UNIT_X = Vec4{ .x = 1.0, .y = 0.0, .z = 0.0, .w = 0.0 };
    pub const UNIT_Y = Vec4{ .x = 0.0, .y = 1.0, .z = 0.0, .w = 0.0 };
    pub const UNIT_Z = Vec4{ .x = 0.0, .y = 0.0, .z = 1.0, .w = 0.0 };
    pub const UNIT_W = Vec4{ .x = 0.0, .y = 0.0, .z = 0.0, .w = 1.0 };
};

const testing = std.testing;
const expectEqual = testing.expectEqual;
const expectApproxEqRel = testing.expectApproxEqRel;

test "Vec4 initialization" {
    const vec = Vec4.init(1.0, 2.0, 3.0, 4.0);
    try expectEqual(vec.x, 1.0);
    try expectEqual(vec.y, 2.0);
    try expectEqual(vec.z, 3.0);
    try expectEqual(vec.w, 4.0);
}

test "Vec4 addition" {
    const vec1 = Vec4.init(1.0, 2.0, 3.0, 4.0);
    const vec2 = Vec4.init(5.0, 6.0, 7.0, 8.0);
    const result = vec1.add(vec2);
    try expectEqual(result.x, 6.0);
    try expectEqual(result.y, 8.0);
    try expectEqual(result.z, 10.0);
    try expectEqual(result.w, 12.0);
}

test "Vec4 scalar multiplication" {
    const vec = Vec4.init(1.0, 2.0, 3.0, 4.0);
    const result = vec.mul(2.0);
    try expectEqual(result.x, 2.0);
    try expectEqual(result.y, 4.0);
    try expectEqual(result.z, 6.0);
    try expectEqual(result.w, 8.0);
}

test "Vec4 dot product" {
    const vec1 = Vec4.init(1.0, 2.0, 3.0, 4.0);
    const vec2 = Vec4.init(5.0, 6.0, 7.0, 8.0);
    const result = vec1.dot(vec2);
    try expectEqual(result, 70.0); // 1*5 + 2*6 + 3*7 + 4*8 = 5 + 12 + 21 + 32 = 70
}

test "Vec4 length" {
    const vec = Vec4.init(2.0, 0.0, 0.0, 0.0);
    try expectEqual(vec.length(), 2.0);

    const vec2 = Vec4.init(1.0, 1.0, 1.0, 1.0);
    try expectEqual(vec2.lengthSquared(), 4.0);
}

test "Vec4 constants" {
    try expectEqual(Vec4.ZERO.x, 0.0);
    try expectEqual(Vec4.ZERO.w, 0.0);
    try expectEqual(Vec4.ONE.x, 1.0);
    try expectEqual(Vec4.UNIT_W.w, 1.0);
    try expectEqual(Vec4.UNIT_W.x, 0.0);
}
