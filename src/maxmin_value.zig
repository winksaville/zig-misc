const builtin = @import("builtin");
const TypeId = builtin.TypeId;

const std = @import("std");
const math = std.math;
const inf_f16 = std.math.inf_f16;
const inf_f32 = std.math.inf_f32;
const inf_f64 = std.math.inf_f64;
const f32_max = std.math.f32_max;
const f64_max = std.math.f64_max;

const maxInt = std.math.maxInt;
const minInt = std.math.minInt;
const assert = std.debug.assert;

pub fn maxFloat(comptime T: type) T {
    return switch (T) {
        f16 => inf_f16,
        f32 => inf_f32,
        f64 => inf_f64,
        else => @compileError("Expecting type to be a float"),
    };
}

test "maxminvalue.maxFloat" {
    assert(maxFloat(f16) == inf_f16);
    assert(maxFloat(f32) == inf_f32);
    assert(maxFloat(f64) == inf_f64);
}

pub fn minFloat(comptime T: type) T {
    return switch (T) {
        f16 => -inf_f16,
        f32 => -inf_f32,
        f64 => -inf_f64,
        else => @compileError("Expecting type to be a float"),
    };
}

test "maxminvalue.minFloat" {
    assert(minFloat(f16) == -inf_f16);
    assert(minFloat(f32) == -inf_f32);
    assert(minFloat(f64) == -inf_f64);
}

pub fn maxValue(comptime T: type) T {
    return switch (@typeId(T)) {
        TypeId.Int => maxInt(T),
        TypeId.Float => maxFloat(T),
        else => @compileError("Expecting type to be a float or int"),
    };
}

test "maxminvalue.maxValue.ints" {
    assert(maxValue(u0) == 0);
    assert(maxValue(u1) == 1);
    assert(maxValue(u8) == 255);
    assert(maxValue(u16) == 65535);
    assert(maxValue(u32) == 4294967295);
    assert(maxValue(u64) == 18446744073709551615);

    assert(maxValue(i0) == 0);
    assert(maxValue(i1) == 0);
    assert(maxValue(i8) == 127);
    assert(maxValue(i16) == 32767);
    assert(maxValue(i32) == 2147483647);
    assert(maxValue(i63) == 4611686018427387903);
    assert(maxValue(i64) == 9223372036854775807);

    assert(maxValue(f16) == inf_f16);
    assert(maxValue(f32) == inf_f32);
    assert(maxValue(f64) == inf_f64);
}

pub fn minValue(comptime T: type) T {
    return switch (@typeId(T)) {
        TypeId.Int => minInt(T),
        TypeId.Float => minFloat(T),
        else => @compileError("Expecting type to be a float or int"),
    };
}

test "maxminvalue.minValue.ints" {
    assert(minValue(u0) == 0);
    assert(minValue(u1) == 0);
    assert(minValue(u8) == 0);
    assert(minValue(u16) == 0);
    assert(minValue(u32) == 0);
    assert(minValue(u63) == 0);
    assert(minValue(u64) == 0);

    assert(minValue(i0) == 0);
    assert(minValue(i1) == -1);
    assert(minValue(i8) == -128);
    assert(minValue(i16) == -32768);
    assert(minValue(i32) == -2147483648);
    assert(minValue(i63) == -4611686018427387904);
    assert(minValue(i64) == -9223372036854775808);

    assert(minValue(f16) == -inf_f16);
    assert(minValue(f32) == -inf_f32);
    assert(minValue(f64) == -inf_f64);
}

test "maxminvalue.maxValue.floats" {
    assert(maxValue(f16) == maxValue(f16));
    assert(maxValue(f32) == maxValue(f16));
    assert(maxValue(f64) == maxValue(f16));
    assert(@intToFloat(f16, maxValue(i16)) < maxValue(f16));
    assert(@intToFloat(f16, maxValue(u16)) == maxValue(f16));
    assert(@intToFloat(f16, maxValue(u32)) == maxValue(f16));
    assert(@intToFloat(f16, maxValue(u64)) == maxValue(f16));
    assert(@intToFloat(f16, maxValue(u128)) == maxValue(f16));

    assert(f32_max < maxValue(f32));
    assert(maxValue(f16) == maxValue(f32));
    assert(maxValue(f32) == maxValue(f32));
    assert(maxValue(f64) == maxValue(f32));
    assert(@intToFloat(f32, maxValue(i32)) < maxValue(f32));
    assert(@intToFloat(f32, maxValue(u32)) < maxValue(f32));
    assert(@intToFloat(f32, maxValue(u64)) < maxValue(f32));
    assert(@intToFloat(f32, maxValue(u128)) == maxValue(f32));

    assert(f64_max < maxValue(f64));
    assert(maxValue(f16) == maxValue(f64));
    assert(maxValue(f32) == maxValue(f64));
    assert(maxValue(f64) == maxValue(f64));
    assert(@intToFloat(f64, maxValue(i64)) < maxValue(f64));
    assert(@intToFloat(f64, maxValue(u64)) < maxValue(f64));
    assert(@intToFloat(f64, maxValue(u128)) < maxValue(f64));
}

test "maxminvalue.minValue.floats" {
    assert(minValue(f16) < 0);
    assert(minValue(f16) < maxValue(f16));
    assert(@intToFloat(f16, minValue(i16)) > minValue(f16));
    assert(@intToFloat(f16, minValue(i32)) == minValue(f16));
    assert(@intToFloat(f16, minValue(i64)) == minValue(f16));
    assert(@intToFloat(f16, minValue(i128)) == minValue(f16));

    assert(minValue(f32) < 0);
    assert(minValue(f32) < maxValue(f32));
    assert(@intToFloat(f32, minValue(i16)) > minValue(f32));
    assert(@intToFloat(f32, minValue(i32)) > minValue(f32));
    assert(@intToFloat(f32, minValue(i64)) > minValue(f32));
    assert(@intToFloat(f32, minValue(i128)) > minValue(f32));

    assert(minValue(f64) < 0);
    assert(minValue(f64) < maxValue(f64));
    assert(@intToFloat(f64, minValue(i16)) > minValue(f64));
    assert(@intToFloat(f64, minValue(i32)) > minValue(f64));
    assert(@intToFloat(f64, minValue(i64)) > minValue(f64));
    assert(@intToFloat(f64, minValue(i128)) > minValue(f64));
}
