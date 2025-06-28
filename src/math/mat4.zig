const std = @import("std");
const Vec3 = @import("vec3.zig").Vec3;
const Vec4 = @import("vec4.zig").Vec4;

/// A 4x4 matrix stored in column-major order
/// Essential for 3D transformations, perspective projections, and homogeneous coordinates
pub const Mat4 = struct {
    // Stored in column-major order: [col0, col1, col2, col3]
    // m[0]  m[4]  m[8]  m[12]
    // m[1]  m[5]  m[9]  m[13]
    // m[2]  m[6]  m[10] m[14]
    // m[3]  m[7]  m[11] m[15]
    m: [16]f32,

    /// Initialize matrix with all elements
    pub fn init(m00: f32, m01: f32, m02: f32, m03: f32, m10: f32, m11: f32, m12: f32, m13: f32, m20: f32, m21: f32, m22: f32, m23: f32, m30: f32, m31: f32, m32: f32, m33: f32) Mat4 {
        return Mat4{
            .m = [16]f32{
                m00, m10, m20, m30, // Column 0
                m01, m11, m21, m31, // Column 1
                m02, m12, m22, m32, // Column 2
                m03, m13, m23, m33, // Column 3
            },
        };
    }

    /// Initialize from four column vectors
    pub fn fromColumns(col0: Vec4, col1: Vec4, col2: Vec4, col3: Vec4) Mat4 {
        return Mat4{ .m = [16]f32{
            col0.x, col0.y, col0.z, col0.w,
            col1.x, col1.y, col1.z, col1.w,
            col2.x, col2.y, col2.z, col2.w,
            col3.x, col3.y, col3.z, col3.w,
        } };
    }

    /// Get element at row, column
    pub fn get(self: Mat4, row: usize, col: usize) f32 {
        return self.m[col * 4 + row];
    }

    /// Set element at row, column
    pub fn set(self: *Mat4, row: usize, col: usize, value: f32) void {
        self.m[col * 4 + row] = value;
    }

    /// Get column as Vec4
    pub fn getColumn(self: Mat4, col: usize) Vec4 {
        const base = col * 4;
        return Vec4.init(self.m[base], self.m[base + 1], self.m[base + 2], self.m[base + 3]);
    }

    /// Get row as Vec4
    pub fn getRow(self: Mat4, row: usize) Vec4 {
        return Vec4.init(self.m[row], // Column 0
            self.m[4 + row], // Column 1
            self.m[8 + row], // Column 2
            self.m[12 + row] // Column 3
        );
    }

    /// Matrix addition
    pub fn add(self: Mat4, other: Mat4) Mat4 {
        var result = Mat4{ .m = undefined };
        for (0..16) |i| {
            result.m[i] = self.m[i] + other.m[i];
        }
        return result;
    }

    /// Matrix subtraction
    pub fn sub(self: Mat4, other: Mat4) Mat4 {
        var result = Mat4{ .m = undefined };
        for (0..16) |i| {
            result.m[i] = self.m[i] - other.m[i];
        }
        return result;
    }

    /// Scalar multiplication
    pub fn mul(self: Mat4, scalar: f32) Mat4 {
        var result = Mat4{ .m = undefined };
        for (0..16) |i| {
            result.m[i] = self.m[i] * scalar;
        }
        return result;
    }

    /// Matrix multiplication
    pub fn mulMat(self: Mat4, other: Mat4) Mat4 {
        var result = Mat4{ .m = undefined };

        for (0..4) |col| {
            for (0..4) |row| {
                var sum: f32 = 0.0;
                for (0..4) |k| {
                    sum += self.get(row, k) * other.get(k, col);
                }
                result.set(row, col, sum);
            }
        }

        return result;
    }

    /// Matrix-vector multiplication (Vec4)
    pub fn mulVec4(self: Mat4, vec: Vec4) Vec4 {
        return Vec4.init(self.get(0, 0) * vec.x + self.get(0, 1) * vec.y + self.get(0, 2) * vec.z + self.get(0, 3) * vec.w, self.get(1, 0) * vec.x + self.get(1, 1) * vec.y + self.get(1, 2) * vec.z + self.get(1, 3) * vec.w, self.get(2, 0) * vec.x + self.get(2, 1) * vec.y + self.get(2, 2) * vec.z + self.get(2, 3) * vec.w, self.get(3, 0) * vec.x + self.get(3, 1) * vec.y + self.get(3, 2) * vec.z + self.get(3, 3) * vec.w);
    }

    /// Matrix-vector multiplication (Vec3 as point, w=1)
    pub fn mulPoint(self: Mat4, vec: Vec3) Vec3 {
        const result = self.mulVec4(Vec4.init(vec.x, vec.y, vec.z, 1.0));
        if (result.w != 0.0) {
            return Vec3.init(result.x / result.w, result.y / result.w, result.z / result.w);
        }
        return Vec3.init(result.x, result.y, result.z);
    }

    /// Matrix-vector multiplication (Vec3 as direction, w=0)
    pub fn mulDirection(self: Mat4, vec: Vec3) Vec3 {
        const result = self.mulVec4(Vec4.init(vec.x, vec.y, vec.z, 0.0));
        return Vec3.init(result.x, result.y, result.z);
    }

    /// Matrix transpose
    pub fn transpose(self: Mat4) Mat4 {
        return Mat4.init(self.get(0, 0), self.get(1, 0), self.get(2, 0), self.get(3, 0), self.get(0, 1), self.get(1, 1), self.get(2, 1), self.get(3, 1), self.get(0, 2), self.get(1, 2), self.get(2, 2), self.get(3, 2), self.get(0, 3), self.get(1, 3), self.get(2, 3), self.get(3, 3));
    }

    /// Calculate determinant
    pub fn determinant(self: Mat4) f32 {
        const m00 = self.get(0, 0);
        const m01 = self.get(0, 1);
        const m02 = self.get(0, 2);
        const m03 = self.get(0, 3);
        const m10 = self.get(1, 0);
        const m11 = self.get(1, 1);
        const m12 = self.get(1, 2);
        const m13 = self.get(1, 3);
        const m20 = self.get(2, 0);
        const m21 = self.get(2, 1);
        const m22 = self.get(2, 2);
        const m23 = self.get(2, 3);
        const m30 = self.get(3, 0);
        const m31 = self.get(3, 1);
        const m32 = self.get(3, 2);
        const m33 = self.get(3, 3);

        return m00 * (m11 * (m22 * m33 - m23 * m32) - m12 * (m21 * m33 - m23 * m31) + m13 * (m21 * m32 - m22 * m31)) -
            m01 * (m10 * (m22 * m33 - m23 * m32) - m12 * (m20 * m33 - m23 * m30) + m13 * (m20 * m32 - m22 * m30)) +
            m02 * (m10 * (m21 * m33 - m23 * m31) - m11 * (m20 * m33 - m23 * m30) + m13 * (m20 * m31 - m21 * m30)) -
            m03 * (m10 * (m21 * m32 - m22 * m31) - m11 * (m20 * m32 - m22 * m30) + m12 * (m20 * m31 - m21 * m30));
    }

    /// Calculate matrix inverse (returns null if matrix is not invertible)
    pub fn inverse(self: Mat4) ?Mat4 {
        const det = self.determinant();
        if (@abs(det) < 0.000001) {
            return null; // Matrix is not invertible
        }

        const invDet = 1.0 / det;
        var result = Mat4{ .m = undefined };

        // Calculate adjugate matrix (cofactor matrix transposed)
        const m = self.m;

        result.m[0] = (m[5] * (m[10] * m[15] - m[11] * m[14]) - m[6] * (m[9] * m[15] - m[11] * m[13]) + m[7] * (m[9] * m[14] - m[10] * m[13])) * invDet;
        result.m[1] = -(m[1] * (m[10] * m[15] - m[11] * m[14]) - m[2] * (m[9] * m[15] - m[11] * m[13]) + m[3] * (m[9] * m[14] - m[10] * m[13])) * invDet;
        result.m[2] = (m[1] * (m[6] * m[15] - m[7] * m[14]) - m[2] * (m[5] * m[15] - m[7] * m[13]) + m[3] * (m[5] * m[14] - m[6] * m[13])) * invDet;
        result.m[3] = -(m[1] * (m[6] * m[11] - m[7] * m[10]) - m[2] * (m[5] * m[11] - m[7] * m[9]) + m[3] * (m[5] * m[10] - m[6] * m[9])) * invDet;

        result.m[4] = -(m[4] * (m[10] * m[15] - m[11] * m[14]) - m[6] * (m[8] * m[15] - m[11] * m[12]) + m[7] * (m[8] * m[14] - m[10] * m[12])) * invDet;
        result.m[5] = (m[0] * (m[10] * m[15] - m[11] * m[14]) - m[2] * (m[8] * m[15] - m[11] * m[12]) + m[3] * (m[8] * m[14] - m[10] * m[12])) * invDet;
        result.m[6] = -(m[0] * (m[6] * m[15] - m[7] * m[14]) - m[2] * (m[4] * m[15] - m[7] * m[12]) + m[3] * (m[4] * m[14] - m[6] * m[12])) * invDet;
        result.m[7] = (m[0] * (m[6] * m[11] - m[7] * m[10]) - m[2] * (m[4] * m[11] - m[7] * m[8]) + m[3] * (m[4] * m[10] - m[6] * m[8])) * invDet;

        result.m[8] = (m[4] * (m[9] * m[15] - m[11] * m[13]) - m[5] * (m[8] * m[15] - m[11] * m[12]) + m[7] * (m[8] * m[13] - m[9] * m[12])) * invDet;
        result.m[9] = -(m[0] * (m[9] * m[15] - m[11] * m[13]) - m[1] * (m[8] * m[15] - m[11] * m[12]) + m[3] * (m[8] * m[13] - m[9] * m[12])) * invDet;
        result.m[10] = (m[0] * (m[5] * m[15] - m[7] * m[13]) - m[1] * (m[4] * m[15] - m[7] * m[12]) + m[3] * (m[4] * m[13] - m[5] * m[12])) * invDet;
        result.m[11] = -(m[0] * (m[5] * m[11] - m[7] * m[9]) - m[1] * (m[4] * m[11] - m[7] * m[8]) + m[3] * (m[4] * m[9] - m[5] * m[8])) * invDet;

        result.m[12] = -(m[4] * (m[9] * m[14] - m[10] * m[13]) - m[5] * (m[8] * m[14] - m[10] * m[12]) + m[6] * (m[8] * m[13] - m[9] * m[12])) * invDet;
        result.m[13] = (m[0] * (m[9] * m[14] - m[10] * m[13]) - m[1] * (m[8] * m[14] - m[10] * m[12]) + m[2] * (m[8] * m[13] - m[9] * m[12])) * invDet;
        result.m[14] = -(m[0] * (m[5] * m[14] - m[6] * m[13]) - m[1] * (m[4] * m[14] - m[6] * m[12]) + m[2] * (m[4] * m[13] - m[5] * m[12])) * invDet;
        result.m[15] = (m[0] * (m[5] * m[10] - m[6] * m[9]) - m[1] * (m[4] * m[10] - m[6] * m[8]) + m[2] * (m[4] * m[9] - m[5] * m[8])) * invDet;

        return result;
    }

    /// Create translation matrix
    pub fn translation(x: f32, y: f32, z: f32) Mat4 {
        return Mat4.init(1.0, 0.0, 0.0, x, 0.0, 1.0, 0.0, y, 0.0, 0.0, 1.0, z, 0.0, 0.0, 0.0, 1.0);
    }

    /// Create translation matrix from Vec3
    pub fn translationVec(vec: Vec3) Mat4 {
        return translation(vec.x, vec.y, vec.z);
    }

    /// Create rotation matrix around X-axis
    pub fn rotationX(angle_rad: f32) Mat4 {
        const cos_a = @cos(angle_rad);
        const sin_a = @sin(angle_rad);
        return Mat4.init(1.0, 0.0, 0.0, 0.0, 0.0, cos_a, -sin_a, 0.0, 0.0, sin_a, cos_a, 0.0, 0.0, 0.0, 0.0, 1.0);
    }

    /// Create rotation matrix around Y-axis
    pub fn rotationY(angle_rad: f32) Mat4 {
        const cos_a = @cos(angle_rad);
        const sin_a = @sin(angle_rad);
        return Mat4.init(cos_a, 0.0, sin_a, 0.0, 0.0, 1.0, 0.0, 0.0, -sin_a, 0.0, cos_a, 0.0, 0.0, 0.0, 0.0, 1.0);
    }

    /// Create rotation matrix around Z-axis
    pub fn rotationZ(angle_rad: f32) Mat4 {
        const cos_a = @cos(angle_rad);
        const sin_a = @sin(angle_rad);
        return Mat4.init(cos_a, -sin_a, 0.0, 0.0, sin_a, cos_a, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0);
    }

    /// Create uniform scale matrix
    pub fn scale(factor: f32) Mat4 {
        return Mat4.init(factor, 0.0, 0.0, 0.0, 0.0, factor, 0.0, 0.0, 0.0, 0.0, factor, 0.0, 0.0, 0.0, 0.0, 1.0);
    }

    /// Create non-uniform scale matrix
    pub fn scaleXYZ(x: f32, y: f32, z: f32) Mat4 {
        return Mat4.init(x, 0.0, 0.0, 0.0, 0.0, y, 0.0, 0.0, 0.0, 0.0, z, 0.0, 0.0, 0.0, 0.0, 1.0);
    }

    /// Create perspective projection matrix
    pub fn perspective(fovy_rad: f32, aspect: f32, near: f32, far: f32) Mat4 {
        const f = 1.0 / @tan(fovy_rad / 2.0);
        const range_inv = 1.0 / (near - far);

        return Mat4.init(f / aspect, 0.0, 0.0, 0.0, 0.0, f, 0.0, 0.0, 0.0, 0.0, (near + far) * range_inv, 2.0 * near * far * range_inv, 0.0, 0.0, -1.0, 0.0);
    }

    /// Create orthographic projection matrix
    pub fn orthographic(left: f32, right: f32, bottom: f32, top: f32, near: f32, far: f32) Mat4 {
        const width = right - left;
        const height = top - bottom;
        const depth = far - near;

        return Mat4.init(2.0 / width, 0.0, 0.0, -(right + left) / width, 0.0, 2.0 / height, 0.0, -(top + bottom) / height, 0.0, 0.0, -2.0 / depth, -(far + near) / depth, 0.0, 0.0, 0.0, 1.0);
    }

    /// Create look-at view matrix
    pub fn lookAt(eye: Vec3, target: Vec3, up: Vec3) Mat4 {
        const forward = target.sub(eye).normalize();
        const right = forward.cross(up).normalize();
        const up_corrected = right.cross(forward);

        return Mat4.init(right.x, up_corrected.x, -forward.x, -right.dot(eye), right.y, up_corrected.y, -forward.y, -up_corrected.dot(eye), right.z, up_corrected.z, -forward.z, forward.dot(eye), 0.0, 0.0, 0.0, 1.0);
    }

    // Common matrix constants
    pub const IDENTITY = Mat4.init(1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, 0.0, 1.0);

    pub const ZERO = Mat4.init(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
};

// Tests
const testing = std.testing;
const expectEqual = testing.expectEqual;
const expectApproxEqRel = testing.expectApproxEqRel;

test "Mat4 initialization" {
    const mat = Mat4.init(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0);

    try expectEqual(mat.get(0, 0), 1.0);
    try expectEqual(mat.get(0, 3), 4.0);
    try expectEqual(mat.get(3, 0), 13.0);
    try expectEqual(mat.get(3, 3), 16.0);
}

test "Mat4 from columns" {
    const col0 = Vec4.init(1.0, 5.0, 9.0, 13.0);
    const col1 = Vec4.init(2.0, 6.0, 10.0, 14.0);
    const col2 = Vec4.init(3.0, 7.0, 11.0, 15.0);
    const col3 = Vec4.init(4.0, 8.0, 12.0, 16.0);
    const mat = Mat4.fromColumns(col0, col1, col2, col3);

    try expectEqual(mat.get(0, 0), 1.0);
    try expectEqual(mat.get(1, 1), 6.0);
    try expectEqual(mat.get(2, 2), 11.0);
    try expectEqual(mat.get(3, 3), 16.0);
}

test "Mat4 get/set operations" {
    var mat = Mat4.IDENTITY;
    mat.set(0, 1, 5.0);
    try expectEqual(mat.get(0, 1), 5.0);

    const col1 = mat.getColumn(1);
    try expectEqual(col1.x, 5.0);
    try expectEqual(col1.y, 1.0);
    try expectEqual(col1.z, 0.0);
    try expectEqual(col1.w, 0.0);

    const row0 = mat.getRow(0);
    try expectEqual(row0.x, 1.0);
    try expectEqual(row0.y, 5.0);
    try expectEqual(row0.z, 0.0);
    try expectEqual(row0.w, 0.0);
}

test "Mat4 arithmetic operations" {
    const mat1 = Mat4.init(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0);
    const mat2 = Mat4.init(16.0, 15.0, 14.0, 13.0, 12.0, 11.0, 10.0, 9.0, 8.0, 7.0, 6.0, 5.0, 4.0, 3.0, 2.0, 1.0);

    const sum = mat1.add(mat2);
    try expectEqual(sum.get(0, 0), 17.0);
    try expectEqual(sum.get(1, 1), 17.0);
    try expectEqual(sum.get(2, 2), 17.0);
    try expectEqual(sum.get(3, 3), 17.0);

    const scaled = mat1.mul(2.0);
    try expectEqual(scaled.get(0, 0), 2.0);
    try expectEqual(scaled.get(1, 1), 12.0);
}

test "Mat4 matrix multiplication" {
    const identity = Mat4.IDENTITY;
    const mat = Mat4.init(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0);

    const result = identity.mulMat(mat);
    try expectEqual(result.get(0, 0), 1.0);
    try expectEqual(result.get(1, 1), 6.0);
    try expectEqual(result.get(2, 2), 11.0);
    try expectEqual(result.get(3, 3), 16.0);
}

test "Mat4 vector multiplication" {
    const mat = Mat4.init(2.0, 0.0, 0.0, 0.0, 0.0, 3.0, 0.0, 0.0, 0.0, 0.0, 4.0, 0.0, 0.0, 0.0, 0.0, 1.0);

    const vec4 = Vec4.init(1.0, 2.0, 3.0, 1.0);
    const result4 = mat.mulVec4(vec4);
    try expectEqual(result4.x, 2.0);
    try expectEqual(result4.y, 6.0);
    try expectEqual(result4.z, 12.0);
    try expectEqual(result4.w, 1.0);

    const vec3 = Vec3.init(1.0, 2.0, 3.0);
    const result_point = mat.mulPoint(vec3);
    try expectEqual(result_point.x, 2.0);
    try expectEqual(result_point.y, 6.0);
    try expectEqual(result_point.z, 12.0);

    const result_dir = mat.mulDirection(vec3);
    try expectEqual(result_dir.x, 2.0);
    try expectEqual(result_dir.y, 6.0);
    try expectEqual(result_dir.z, 12.0);
}

test "Mat4 transpose" {
    const mat = Mat4.init(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0);
    const transposed = mat.transpose();

    try expectEqual(transposed.get(0, 0), 1.0);
    try expectEqual(transposed.get(0, 1), 5.0);
    try expectEqual(transposed.get(1, 0), 2.0);
    try expectEqual(transposed.get(3, 2), 12.0);
}

test "Mat4 determinant and inverse" {
    const mat = Mat4.init(2.0, 0.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0, 0.0, 2.0, 0.0, 0.0, 0.0, 0.0, 1.0);

    try expectEqual(mat.determinant(), 8.0);

    const inv = mat.inverse().?;
    try expectEqual(inv.get(0, 0), 0.5);
    try expectEqual(inv.get(1, 1), 0.5);
    try expectEqual(inv.get(2, 2), 0.5);
    try expectEqual(inv.get(3, 3), 1.0);

    // Test that mat * inv = identity
    const product = mat.mulMat(inv);
    try expectApproxEqRel(product.get(0, 0), 1.0, 0.0001);
    try expectApproxEqRel(product.get(1, 1), 1.0, 0.0001);
    try expectApproxEqRel(product.get(2, 2), 1.0, 0.0001);
    try expectApproxEqRel(product.get(3, 3), 1.0, 0.0001);
}

test "Mat4 transformations" {
    // Test translation
    const trans = Mat4.translation(5.0, 10.0, 15.0);
    const point = Vec3.init(0.0, 0.0, 0.0);
    const translated = trans.mulPoint(point);
    try expectEqual(translated.x, 5.0);
    try expectEqual(translated.y, 10.0);
    try expectEqual(translated.z, 15.0);

    // Test scale
    const scale_mat = Mat4.scaleXYZ(2.0, 3.0, 4.0);
    const scaled = scale_mat.mulPoint(Vec3.init(1.0, 1.0, 1.0));
    try expectEqual(scaled.x, 2.0);
    try expectEqual(scaled.y, 3.0);
    try expectEqual(scaled.z, 4.0);

    // Test rotation (90 degrees around Z)
    const pi = std.math.pi;
    const rotZ = Mat4.rotationZ(pi / 2.0);
    const rotated = rotZ.mulPoint(Vec3.init(1.0, 0.0, 0.0));
    try testing.expect(@abs(rotated.x) < 0.001);
    try expectApproxEqRel(rotated.y, 1.0, 0.001);
    try testing.expect(@abs(rotated.z) < 0.001);
}

test "Mat4 projections" {
    // Test perspective projection
    const pi = std.math.pi;
    const persp = Mat4.perspective(pi / 4.0, 16.0 / 9.0, 0.1, 100.0);
    const projected = persp.mulVec4(Vec4.init(0.0, 0.0, -1.0, 1.0));

    // Point at -1 in view space should project reasonably
    try testing.expect(projected.z != 0.0); // Should have some Z value
    try testing.expect(projected.w > 0.0); // w should be positive

    // Test orthographic projection
    const ortho = Mat4.orthographic(-1.0, 1.0, -1.0, 1.0, 0.1, 100.0);
    const ortho_projected = ortho.mulVec4(Vec4.init(0.5, 0.5, -1.0, 1.0));
    try expectEqual(ortho_projected.x, 0.5);
    try expectEqual(ortho_projected.y, 0.5);
    try expectEqual(ortho_projected.w, 1.0);
}

test "Mat4 look-at" {
    const eye = Vec3.init(0.0, 0.0, 5.0);
    const target = Vec3.init(0.0, 0.0, 0.0);
    const up = Vec3.init(0.0, 1.0, 0.0);

    const view = Mat4.lookAt(eye, target, up);

    // Transform the eye position - should be at origin in view space
    const transformed_eye = view.mulPoint(eye);
    try expectApproxEqRel(transformed_eye.x, 0.0, 0.0001);
    try expectApproxEqRel(transformed_eye.y, 0.0, 0.0001);
    try expectApproxEqRel(transformed_eye.z, 0.0, 0.0001);

    // Transform target - should be at negative Z
    const transformed_target = view.mulPoint(target);
    try testing.expect(transformed_target.z < 0.0);
}

test "Mat4 constants" {
    try expectEqual(Mat4.IDENTITY.get(0, 0), 1.0);
    try expectEqual(Mat4.IDENTITY.get(1, 1), 1.0);
    try expectEqual(Mat4.IDENTITY.get(2, 2), 1.0);
    try expectEqual(Mat4.IDENTITY.get(3, 3), 1.0);
    try expectEqual(Mat4.IDENTITY.get(0, 1), 0.0);

    try expectEqual(Mat4.ZERO.get(0, 0), 0.0);
    try expectEqual(Mat4.ZERO.get(1, 1), 0.0);
    try expectEqual(Mat4.ZERO.get(2, 2), 0.0);
    try expectEqual(Mat4.ZERO.get(3, 3), 0.0);
}
