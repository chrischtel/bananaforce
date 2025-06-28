const std = @import("std");

pub const Vec2 = struct {
    x: f32,
    y: f32,

    pub fn init(x: f32, y: f32) Vec2 {
        return Vec2{ .x = x, .y = y };
    }

    pub const ZERO: Vec2 = Vec2{ .x = 0, .y = 0 };

    pub fn add(self: Vec2, other: Vec2) Vec2 {
        return Vec2{ .x = self.x + other.x, .y = self.y + other.y };
    }
    pub fn sub(self: Vec2, other: Vec2) Vec2 {
        return Vec2{ .x = self.x - other.x, .y = self.y - other.y };
    }
    pub fn mul(self: Vec2, scalar: f32) Vec2 {
        return Vec2{ .x = self.x * scalar, .y = self.y * scalar };
    }
    pub fn div(self: Vec2, scalar: f32) Vec2 {
        if (scalar == 0) {
            // Handle division by zero, could also panic or return an error
            return Vec2{ .x = 0, .y = 0 };
        }
        return Vec2{ .x = self.x / scalar, .y = self.y / scalar };
    }

    pub fn length(self: Vec2) f32 {
        return @sqrt(self.x * self.x + self.y * self.y);
    }
    pub fn length_squared(self: Vec2) f32 {
        return self.x * self.x + self.y * self.y;
    }
    pub fn normalize(self: Vec2) Vec2 {
        const len_sq = self.length_squared();
        if (len_sq < std.math.floatEps(f32)) {
            return Vec2.ZERO;
        }
        const len = @sqrt(len_sq);
        return self.div(len);
    }

    pub fn dot(self: Vec2, other: Vec2) f32 {
        return self.x * other.x + self.y * other.y;
    }
    pub fn perp(self: Vec2) Vec2 {
        return Vec2{ .x = -self.y, .y = self.x };
    }
};

// Tests
const testing = std.testing;
const expectEqual = testing.expectEqual;
const expectApproxEqRel = testing.expectApproxEqRel;

test "Vec2 initialization" {
    const v = Vec2.init(3.0, 4.0);
    try expectEqual(@as(f32, 3.0), v.x);
    try expectEqual(@as(f32, 4.0), v.y);
}

test "Vec2 addition" {
    const a = Vec2.init(1.0, 2.0);
    const b = Vec2.init(3.0, 4.0);
    const result = a.add(b);
    try expectEqual(@as(f32, 4.0), result.x);
    try expectEqual(@as(f32, 6.0), result.y);
}

test "Vec2 length" {
    const v = Vec2.init(3.0, 4.0);
    try expectApproxEqRel(@as(f32, 5.0), v.length(), 0.001);
    try expectEqual(@as(f32, 25.0), v.length_squared());
}

test "Vec2 normalize" {
    const v = Vec2.init(3.0, 4.0);
    const normalized = v.normalize();
    try expectApproxEqRel(@as(f32, 1.0), normalized.length(), 0.001);

    // Test zero vector
    const zero = Vec2.ZERO.normalize();
    try expectEqual(Vec2.ZERO.x, zero.x);
    try expectEqual(Vec2.ZERO.y, zero.y);
}

test "Vec2 dot product" {
    const a = Vec2.init(1.0, 2.0);
    const b = Vec2.init(3.0, 4.0);
    try expectEqual(@as(f32, 11.0), a.dot(b)); // 1*3 + 2*4 = 11
}

test "Vec2 perpendicular" {
    const v = Vec2.init(1.0, 0.0);
    const p = v.perp();
    try expectEqual(@as(f32, 0.0), p.x);
    try expectEqual(@as(f32, 1.0), p.y);
}
