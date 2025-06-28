const std = @import("std");
const Vec3 = @import("vec3.zig").Vec3;

/// A 3x3 matrix stored in column-major order
/// Useful for 2D transformations, rotations, and general 3x3 linear algebra.
pub const Mat3 = struct {
    // Stored in column-major order: [col0, col1, col2]
    // m[0] m[3] m[6]
    // m[1] m[4] m[7]
    // m[2] m[5] m[8]
    m: [9]f32,

    /// Initialize matrix with all elements
    pub fn init(m00: f32, m01: f32, m02: f32, m10: f32, m11: f32, m12: f32, m20: f32, m21: f32, m22: f32) Mat3 {
        return Mat3{
            .m = [9]f32{
                m00, m10, m20, // Column 0
                m01, m11, m21, // Column 1
                m02, m12, m22, // Column 2
            },
        };
    }

    /// Initialize from three column vectors
    pub fn fromColumns(col0: Vec3, col1: Vec3, col2: Vec3) Mat3 {
        return Mat3{ .m = [9]f32{
            col0.x, col0.y, col0.z,
            col1.x, col1.y, col1.z,
            col2.x, col2.y, col2.z,
        } };
    }

    /// Get element at row, column
    pub fn get(self: Mat3, row: usize, col: usize) f32 {
        return self.m[col * 3 + row];
    }

    /// Set element at row, column
    pub fn set(self: *Mat3, row: usize, col: usize, value: f32) void {
        self.m[col * 3 + row] = value;
    }

    /// Get column as Vec3
    pub fn getColumn(self: Mat3, col: usize) Vec3 {
        const base = col * 3;
        return Vec3.init(self.m[base], self.m[base + 1], self.m[base + 2]);
    }

    /// Get row as Vec3
    pub fn getRow(self: Mat3, row: usize) Vec3 {
        return Vec3.init(self.m[row], // Column 0
            self.m[3 + row], // Column 1
            self.m[6 + row] // Column 2
        );
    }

    /// Matrix addition
    pub fn add(self: Mat3, other: Mat3) Mat3 {
        var result = Mat3{ .m = undefined };
        for (0..9) |i| {
            result.m[i] = self.m[i] + other.m[i];
        }
        return result;
    }

    /// Matrix subtraction
    pub fn sub(self: Mat3, other: Mat3) Mat3 {
        var result = Mat3{ .m = undefined };
        for (0..9) |i| {
            result.m[i] = self.m[i] - other.m[i];
        }
        return result;
    }

    /// Scalar multiplication
    pub fn mul(self: Mat3, scalar: f32) Mat3 {
        var result = Mat3{ .m = undefined };
        for (0..9) |i| {
            result.m[i] = self.m[i] * scalar;
        }
        return result;
    }

    /// Matrix multiplication
    pub fn mulMat(self: Mat3, other: Mat3) Mat3 {
        var result = Mat3{ .m = undefined };

        for (0..3) |col| {
            for (0..3) |row| {
                var sum: f32 = 0.0;
                for (0..3) |k| {
                    sum += self.get(row, k) * other.get(k, col);
                }
                result.set(row, col, sum);
            }
        }

        return result;
    }

    /// Matrix-vector multiplication
    pub fn mulVec(self: Mat3, vec: Vec3) Vec3 {
        return Vec3.init(self.get(0, 0) * vec.x + self.get(0, 1) * vec.y + self.get(0, 2) * vec.z, self.get(1, 0) * vec.x + self.get(1, 1) * vec.y + self.get(1, 2) * vec.z, self.get(2, 0) * vec.x + self.get(2, 1) * vec.y + self.get(2, 2) * vec.z);
    }

    /// Matrix transpose
    pub fn transpose(self: Mat3) Mat3 {
        return Mat3.init(self.get(0, 0), self.get(1, 0), self.get(2, 0), self.get(0, 1), self.get(1, 1), self.get(2, 1), self.get(0, 2), self.get(1, 2), self.get(2, 2));
    }

    /// Calculate determinant
    pub fn determinant(self: Mat3) f32 {
        const a = self.get(0, 0);
        const b = self.get(0, 1);
        const c = self.get(0, 2);
        const d = self.get(1, 0);
        const e = self.get(1, 1);
        const f = self.get(1, 2);
        const g = self.get(2, 0);
        const h = self.get(2, 1);
        const i = self.get(2, 2);

        return a * (e * i - f * h) - b * (d * i - f * g) + c * (d * h - e * g);
    }

    /// Calculate matrix inverse (returns null if matrix is not invertible)
    pub fn inverse(self: Mat3) ?Mat3 {
        const det = self.determinant();
        if (@abs(det) < 0.000001) {
            return null; // Matrix is not invertible
        }

        const invDet = 1.0 / det;

        // Calculate cofactor matrix and transpose (adjugate)
        const a = self.get(0, 0);
        const b = self.get(0, 1);
        const c = self.get(0, 2);
        const d = self.get(1, 0);
        const e = self.get(1, 1);
        const f = self.get(1, 2);
        const g = self.get(2, 0);
        const h = self.get(2, 1);
        const i = self.get(2, 2);

        return Mat3.init((e * i - f * h) * invDet, (c * h - b * i) * invDet, (b * f - c * e) * invDet, (f * g - d * i) * invDet, (a * i - c * g) * invDet, (c * d - a * f) * invDet, (d * h - e * g) * invDet, (b * g - a * h) * invDet, (a * e - b * d) * invDet);
    }

    /// Create a 2D rotation matrix (around Z-axis)
    pub fn rotation2D(angle_rad: f32) Mat3 {
        const cos_a = @cos(angle_rad);
        const sin_a = @sin(angle_rad);
        return Mat3.init(cos_a, -sin_a, 0.0, sin_a, cos_a, 0.0, 0.0, 0.0, 1.0);
    }

    /// Create a 2D scale matrix
    pub fn scale2D(scale_x: f32, scale_y: f32) Mat3 {
        return Mat3.init(scale_x, 0.0, 0.0, 0.0, scale_y, 0.0, 0.0, 0.0, 1.0);
    }

    /// Create a 2D translation matrix
    pub fn translation2D(x: f32, y: f32) Mat3 {
        return Mat3.init(1.0, 0.0, x, 0.0, 1.0, y, 0.0, 0.0, 1.0);
    }

    /// Create rotation matrix around X-axis
    pub fn rotationX(angle_rad: f32) Mat3 {
        const cos_a = @cos(angle_rad);
        const sin_a = @sin(angle_rad);
        return Mat3.init(1.0, 0.0, 0.0, 0.0, cos_a, -sin_a, 0.0, sin_a, cos_a);
    }

    /// Create rotation matrix around Y-axis
    pub fn rotationY(angle_rad: f32) Mat3 {
        const cos_a = @cos(angle_rad);
        const sin_a = @sin(angle_rad);
        return Mat3.init(cos_a, 0.0, sin_a, 0.0, 1.0, 0.0, -sin_a, 0.0, cos_a);
    }

    /// Create rotation matrix around Z-axis
    pub fn rotationZ(angle_rad: f32) Mat3 {
        return rotation2D(angle_rad);
    }

    /// Create uniform scale matrix
    pub fn scale(factor: f32) Mat3 {
        return Mat3.init(factor, 0.0, 0.0, 0.0, factor, 0.0, 0.0, 0.0, factor);
    }

    /// Create non-uniform scale matrix
    pub fn scaleXYZ(x: f32, y: f32, z: f32) Mat3 {
        return Mat3.init(x, 0.0, 0.0, 0.0, y, 0.0, 0.0, 0.0, z);
    }

    // Common matrix constants
    pub const IDENTITY = Mat3.init(1.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 1.0);

    pub const ZERO = Mat3.init(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
};

// Tests
const testing = std.testing;
const expectEqual = testing.expectEqual;
const expectApproxEqRel = testing.expectApproxEqRel;

test "Mat3 initialization" {
    const mat = Mat3.init(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0);

    try expectEqual(mat.get(0, 0), 1.0);
    try expectEqual(mat.get(0, 1), 2.0);
    try expectEqual(mat.get(1, 0), 4.0);
    try expectEqual(mat.get(2, 2), 9.0);
}

test "Mat3 from columns" {
    const col0 = Vec3.init(1.0, 4.0, 7.0);
    const col1 = Vec3.init(2.0, 5.0, 8.0);
    const col2 = Vec3.init(3.0, 6.0, 9.0);
    const mat = Mat3.fromColumns(col0, col1, col2);

    try expectEqual(mat.get(0, 0), 1.0);
    try expectEqual(mat.get(1, 1), 5.0);
    try expectEqual(mat.get(2, 2), 9.0);
}

test "Mat3 get/set operations" {
    var mat = Mat3.IDENTITY;
    mat.set(0, 1, 5.0);
    try expectEqual(mat.get(0, 1), 5.0);

    const col1 = mat.getColumn(1);
    try expectEqual(col1.x, 5.0);
    try expectEqual(col1.y, 1.0);
    try expectEqual(col1.z, 0.0);

    const row0 = mat.getRow(0);
    try expectEqual(row0.x, 1.0);
    try expectEqual(row0.y, 5.0);
    try expectEqual(row0.z, 0.0);
}

test "Mat3 arithmetic operations" {
    const mat1 = Mat3.init(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0);
    const mat2 = Mat3.init(9.0, 8.0, 7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0);

    const sum = mat1.add(mat2);
    try expectEqual(sum.get(0, 0), 10.0);
    try expectEqual(sum.get(1, 1), 10.0);
    try expectEqual(sum.get(2, 2), 10.0);

    const diff = mat1.sub(mat2);
    try expectEqual(diff.get(0, 0), -8.0);
    try expectEqual(diff.get(1, 1), 0.0);
    try expectEqual(diff.get(2, 2), 8.0);

    const scaled = mat1.mul(2.0);
    try expectEqual(scaled.get(0, 0), 2.0);
    try expectEqual(scaled.get(1, 1), 10.0);
}

test "Mat3 matrix multiplication" {
    const identity = Mat3.IDENTITY;
    const mat = Mat3.init(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0);

    const result = identity.mulMat(mat);
    try expectEqual(result.get(0, 0), 1.0);
    try expectEqual(result.get(1, 1), 5.0);
    try expectEqual(result.get(2, 2), 9.0);
}

test "Mat3 vector multiplication" {
    const mat = Mat3.init(2.0, 0.0, 0.0, 0.0, 3.0, 0.0, 0.0, 0.0, 4.0);
    const vec = Vec3.init(1.0, 2.0, 3.0);
    const result = mat.mulVec(vec);

    try expectEqual(result.x, 2.0);
    try expectEqual(result.y, 6.0);
    try expectEqual(result.z, 12.0);
}

test "Mat3 transpose" {
    const mat = Mat3.init(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0);
    const transposed = mat.transpose();

    try expectEqual(transposed.get(0, 0), 1.0);
    try expectEqual(transposed.get(0, 1), 4.0);
    try expectEqual(transposed.get(1, 0), 2.0);
    try expectEqual(transposed.get(1, 2), 8.0);
    try expectEqual(transposed.get(2, 1), 6.0);
}

test "Mat3 determinant" {
    const mat = Mat3.init(1.0, 2.0, 3.0, 0.0, 1.0, 4.0, 5.0, 6.0, 0.0);
    const det = mat.determinant();
    try expectEqual(det, 1.0);

    try expectEqual(Mat3.IDENTITY.determinant(), 1.0);
}

test "Mat3 inverse" {
    const mat = Mat3.init(2.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0, 2.0);

    const inv = mat.inverse().?;
    try expectEqual(inv.get(0, 0), 0.5);
    try expectEqual(inv.get(1, 1), 0.5);
    try expectEqual(inv.get(2, 2), 0.5);

    // Test that mat * inv = identity
    const product = mat.mulMat(inv);
    try expectApproxEqRel(product.get(0, 0), 1.0, 0.0001);
    try expectApproxEqRel(product.get(1, 1), 1.0, 0.0001);
    try expectApproxEqRel(product.get(2, 2), 1.0, 0.0001);
}

test "Mat3 2D transformations" {
    const pi = std.math.pi;

    // Test 90-degree rotation
    const rot90 = Mat3.rotation2D(pi / 2.0);
    const vec = Vec3.init(1.0, 0.0, 1.0);
    const rotated = rot90.mulVec(vec);

    try testing.expect(@abs(rotated.x) < 0.001);
    try expectApproxEqRel(rotated.y, 1.0, 0.001);
    try expectApproxEqRel(rotated.z, 1.0, 0.001);

    // Test scale
    const scale_mat = Mat3.scale2D(2.0, 3.0);
    const scaled = scale_mat.mulVec(Vec3.init(1.0, 1.0, 1.0));
    try expectEqual(scaled.x, 2.0);
    try expectEqual(scaled.y, 3.0);
    try expectEqual(scaled.z, 1.0);

    // Test translation
    const trans = Mat3.translation2D(5.0, 10.0);
    const translated = trans.mulVec(Vec3.init(0.0, 0.0, 1.0));
    try expectEqual(translated.x, 5.0);
    try expectEqual(translated.y, 10.0);
    try expectEqual(translated.z, 1.0);
}

test "Mat3 3D rotations" {
    const pi = std.math.pi;

    // Test X rotation
    const rotX = Mat3.rotationX(pi / 2.0);
    const vecY = Vec3.init(0.0, 1.0, 0.0);
    const rotatedX = rotX.mulVec(vecY);

    try testing.expect(@abs(rotatedX.x) < 0.001);
    try testing.expect(@abs(rotatedX.y) < 0.001);
    try expectApproxEqRel(rotatedX.z, 1.0, 0.001);

    // Test Y rotation
    const rotY = Mat3.rotationY(pi / 2.0);
    const vecZ = Vec3.init(0.0, 0.0, 1.0);
    const rotatedY = rotY.mulVec(vecZ);

    try expectApproxEqRel(rotatedY.x, 1.0, 0.001);
    try testing.expect(@abs(rotatedY.y) < 0.001);
    try testing.expect(@abs(rotatedY.z) < 0.001);
}

test "Mat3 constants" {
    try expectEqual(Mat3.IDENTITY.get(0, 0), 1.0);
    try expectEqual(Mat3.IDENTITY.get(1, 1), 1.0);
    try expectEqual(Mat3.IDENTITY.get(2, 2), 1.0);
    try expectEqual(Mat3.IDENTITY.get(0, 1), 0.0);

    try expectEqual(Mat3.ZERO.get(0, 0), 0.0);
    try expectEqual(Mat3.ZERO.get(1, 1), 0.0);
    try expectEqual(Mat3.ZERO.get(2, 2), 0.0);
}
