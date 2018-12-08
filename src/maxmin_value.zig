const builtin = @import("builtin");
const TypeId = builtin.TypeId;

const std = @import("std");
const math = std.math;
const inf_f16 = std.math.inf_f16;
const inf_f32 = std.math.inf_f32;
const inf_f64 = std.math.inf_f64;
const f16_max = std.math.f16_max;
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

/// Return the non-infinite max value
pub fn nonInfMaxFloat(comptime T: type) T {
    return switch (T) {
        f16 => f16_max,
        f32 => f32_max,
        f64 => f64_max,
        else => @compileError("Expecting type to be a float"),
    };
}

test "maxminvalue.nonInfMaxFloat" {
    assert(nonInfMaxFloat(f16) == f16_max);
    assert(nonInfMaxFloat(f32) == f32_max);
    assert(nonInfMaxFloat(f64) == f64_max);
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

/// Return the non-infinite min value
pub fn nonInfMinFloat(comptime T: type) T {
    return -nonInfMaxFloat(T);
}

test "maxminvalue.nonInfMinFloat" {
    assert(nonInfMinFloat(f16) == -nonInfMaxFloat(f16));
    assert(nonInfMinFloat(f32) == -nonInfMaxFloat(f32));
    assert(nonInfMinFloat(f64) == -nonInfMaxFloat(f64));
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

pub fn nonInfMaxValue(comptime T: type) T {
    return switch (@typeId(T)) {
        TypeId.Int => maxValue(T),
        TypeId.Float => nonInfMaxFloat(T),
        else => @compileError("Expecting type to be a float or int"),
    };
}

test "maxminvalue.nonInfMaxValue" {
    assert(nonInfMaxValue(u0) == maxValue(u0));
    assert(nonInfMaxValue(i1) == maxValue(i1));
    assert(nonInfMaxValue(u32) == maxValue(u32));
    assert(nonInfMaxValue(i32) == maxValue(i32));
    assert(nonInfMaxValue(u127) == maxValue(u127));
    assert(nonInfMaxValue(i127) == maxValue(i127));
    assert(nonInfMaxValue(u128) == maxValue(u128));
    assert(nonInfMaxValue(i128) == maxValue(i128));
    assert(nonInfMaxValue(f16) == f16_max);
    assert(nonInfMaxValue(f32) == f32_max);
    assert(nonInfMaxValue(f64) == f64_max);
}

pub fn nonInfMinValue(comptime T: type) T {
    return switch (@typeId(T)) {
        TypeId.Int => minValue(T),
        TypeId.Float => nonInfMinFloat(T),
        else => @compileError("Expecting type to be a float or int"),
    };
}

test "maxminvalue.nonInfMinValue" {
    assert(nonInfMinValue(u0) == minValue(u0));
    assert(nonInfMinValue(i1) == minValue(i1));
    assert(nonInfMinValue(u32) == minValue(u32));
    assert(nonInfMinValue(i32) == minValue(i32));
    assert(nonInfMinValue(u127) == minValue(u127));
    assert(nonInfMinValue(u128) == minValue(u128));
    assert(nonInfMinValue(f16) == -math.f16_max);
    assert(nonInfMinValue(f32) == -math.f32_max);
    assert(nonInfMinValue(f64) == -math.f64_max);
}

/// Numeric cast
pub fn numCast(comptime T: type, v: var) T {
    const Tv = @typeOf(v);

    return switch (@typeId(T)) {
        TypeId.Float => switch (@typeId(Tv)) {
            TypeId.ComptimeFloat, TypeId.Float => @floatCast(T, v),
            TypeId.ComptimeInt, TypeId.Int => @intToFloat(T, v),
            else => @compileError("Expected Float or Int type"),
        },
        TypeId.Int => switch (@typeId(Tv)) {
            TypeId.ComptimeFloat, TypeId.Float => @floatToInt(T, v),
            TypeId.ComptimeInt, TypeId.Int => @intCast(T, v),
            else => @compileError("Expected Float or Int type"),
        },
        else => @compileError("Expected Float or Int type"),
    };
}

test "numCast" {
    var oneF32: f32 = 1.0;
    var oneU32: u32 = 1;
    assert(oneF32 == numCast(f32, oneU32));
    assert(oneU32 == numCast(u32, oneF32));

    assert(1 == @floatToInt(i65, oneF32));

    assert(0 == numCast(u0, 0));
    assert(0 == numCast(u1, 0));
    assert(1 == numCast(u1, 1));
    assert(1 == numCast(u128, 1));
    assert(0 == numCast(i1, 0));
    assert(-1 == numCast(i1, -1));
    assert(0 == numCast(i128, 0));
    assert(-1 == numCast(i128, -1));
    assert(1 == numCast(f16, 1));
    assert(1 == numCast(f32, 1));
    assert(1 == numCast(f64, 1));
}

/// Saturating cast of numeric types.
pub fn saturateCast(comptime T: type, v: var) T {
    const LargestFloatType = f64;
    const LargestIntType = i128;
    const LargestUintType = u128;
    const Tv = @typeOf(v);

    // We have to special cast u0
    switch (T) {
        u0 => return 0,
        else => {},
    }
    switch (Tv) {
        u0 => return 0,
        else => {},
    }

    var r: T = undefined;
    return switch (@typeId(T)) {
        TypeId.Float => switch (@typeId(Tv)) {
            TypeId.ComptimeFloat, TypeId.Float => b1: {
                if (v < 0.0) {
                    r = if (v >= nonInfMinValue(T)) numCast(T, v) else nonInfMinValue(T);
                    break :b1 r;
                } else {
                    r = if (v <= nonInfMaxValue(T)) numCast(T, v) else nonInfMaxValue(T);
                    break :b1 r;
                }
            },
            TypeId.ComptimeInt, TypeId.Int => b2: {
                var vFloat = @intToFloat(LargestFloatType, v);
                if (v < 0) {
                    const minFloatT = @floatCast(LargestFloatType, nonInfMinValue(T));
                    r = if (vFloat >= minFloatT) numCast(T, v) else nonInfMinValue(T);
                    break :b2 r;
                } else {
                    const maxFloatT = @floatCast(LargestFloatType, nonInfMaxValue(T));
                    r = if (vFloat <= maxFloatT) numCast(T, v) else nonInfMaxValue(T);
                    break :b2 r;
                }
            },
            else => @compileError("Expected Float or Int type"),
        },
        TypeId.Int => switch (@typeId(Tv)) {
            TypeId.ComptimeFloat, TypeId.Float => b3: {
                if (v < 0.0) {
                    const minFloatT = @intToFloat(LargestFloatType, nonInfMinValue(T));
                    r = if (v >= minFloatT) numCast(T, v) else nonInfMinValue(T);
                    break :b3 r;
                } else {
                    const maxFloatT = @intToFloat(LargestFloatType, nonInfMaxValue(T));
                    r = if (v <= maxFloatT) numCast(T, v) else nonInfMaxValue(T);
                    break :b3 r;
                }
            },
            TypeId.ComptimeInt, TypeId.Int => b4: {
                if (v < 0) {
                    r = if (v >= nonInfMinValue(T)) numCast(T, v) else nonInfMinValue(T);
                    break :b4 r;
                } else {
                    r = if (v <= nonInfMaxValue(T)) numCast(T, v) else nonInfMaxValue(T);
                    break :b4 r;
                }
            },
            else => @compileError("Expected Float or Int type"),
        },
        else => @compileError("Expected Float or Int type"),
    };
}

test "saturateCast" {
    assert(nonInfMinValue(f32) == saturateCast(f32, minValue(f64)));
    assert(nonInfMinValue(f32) == saturateCast(f32, nonInfMinValue(f64)));
    assert(-1000.123 == saturateCast(f32, f64(-1000.123)));
    assert(-1.0 == saturateCast(f32, f64(-1.0)));
    assert(-0.0 == saturateCast(f32, f64(-0.0)));
    assert(0.0 == saturateCast(f32, f64(0.0)));
    assert(1 == saturateCast(f32, f64(1)));
    assert(1000.123 == saturateCast(f32, f64(1000.123)));
    assert(nonInfMaxValue(f32) == saturateCast(f32, nonInfMaxValue(f64)));
    assert(nonInfMaxValue(f32) == saturateCast(f32, maxValue(f64)));

    assert(nonInfMinValue(f64) == saturateCast(f64, minValue(f64)));
    assert(nonInfMinValue(f64) == saturateCast(f64, nonInfMinValue(f64)));
    assert(-1000.123 == saturateCast(f64, f64(-1000.123)));
    assert(-1.0 == saturateCast(f64, f64(-1.0)));
    assert(-0.0 == saturateCast(f64, f64(-0.0)));
    assert(0.0 == saturateCast(f64, f64(0.0)));
    assert(1 == saturateCast(f64, f64(1)));
    assert(1000.123 == saturateCast(f64, f64(1000.123)));
    assert(nonInfMaxValue(f64) == saturateCast(f64, nonInfMaxValue(f64)));
    assert(nonInfMaxValue(f64) == saturateCast(f64, maxValue(f64)));

    assert(nonInfMinValue(i1) == saturateCast(i1, minValue(f64)));
    assert(nonInfMinValue(i1) == saturateCast(i1, nonInfMinValue(f64)));
    assert(-1 == saturateCast(i1, f64(-1123.1)));
    assert(-1 == saturateCast(i1, f64(-1123.9)));
    assert(-1 == saturateCast(i1, f64(-1.0)));
    assert(0 == saturateCast(i1, f64(-0.0)));
    assert(0 == saturateCast(i1, f64(0.0)));
    assert(0 == saturateCast(i1, f64(1)));
    assert(0 == saturateCast(i1, f64(1123.1)));
    assert(0 == saturateCast(i1, f64(1123.9)));
    assert(nonInfMaxValue(i1) == saturateCast(i1, nonInfMaxValue(f64)));
    assert(nonInfMaxValue(i1) == saturateCast(i1, maxValue(f64)));

    assert(nonInfMinValue(i32) == saturateCast(i32, minValue(f64)));
    assert(nonInfMinValue(i32) == saturateCast(i32, nonInfMinValue(f64)));
    assert(-1123 == saturateCast(i32, f64(-1123.1)));
    assert(-1123 == saturateCast(i32, f64(-1123.9)));
    assert(-1 == saturateCast(i32, f64(-1.0)));
    assert(0 == saturateCast(i32, f64(-0.0)));
    assert(0 == saturateCast(i32, f64(0.0)));
    assert(1 == saturateCast(i32, f64(1)));
    assert(1123 == saturateCast(i32, f64(1123.1)));
    assert(1123 == saturateCast(i32, f64(1123.9)));
    assert(nonInfMaxValue(i32) == saturateCast(i32, nonInfMaxValue(f64)));
    assert(nonInfMaxValue(i32) == saturateCast(i32, maxValue(f64)));


// Fixed with ziglang/zig PR #1820 (https://github.com/ziglang/zig/pull/1820) if and when it gets merged

// Compiler bug for any i65..i128
//   $ zig test modules/zig-misc/src/maxmin_value.zig 
//   lld: error: undefined symbol: __fixdfti
//   >>> referenced by maxmin_value.zig:237 (/home/wink/prgs/graphics/zig-3d-soft-engine/modules/zig-misc/src/maxmin_value.zig:237)
//   >>>               zig-cache/test.o:(numCast.104)
//    assert(1 == saturateCast(i65, f64(1.0)));
//    assert(1 == saturateCast(i128, f64(1.0)));

//    assert(nonInfMinValue(i128) == saturateCast(i128, minValue(f64)));
//    assert(nonInfMinValue(i128) == saturateCast(i128, nonInfMinValue(f64)));
//    assert(-1123 == saturateCast(i128, f64(-1123.1)));
//    assert(-1123 == saturateCast(i128, f64(-1123.9)));
//    assert(-1 == saturateCast(i128, f64(-1.0)));
//    assert(0 == saturateCast(i128, f64(-0.0)));
//    assert(0 == saturateCast(i128, f64(0.0)));
//    assert(1 == saturateCast(i128, f64(1.0)));
//    assert(1123 == saturateCast(i128, f64(1123.1)));
//    assert(1123 == saturateCast(i128, f64(1123.9)));
//    assert(nonInfMaxValue(i128) == saturateCast(i128, nonInfMaxValue(f64)));
//    assert(nonInfMaxValue(i128) == saturateCast(i128, maxValue(f64)));

    // u0 not working
    //  $ zig test src/window.zig --test-filter saturateCast
    //  zig: ../src/codegen.cpp:2816: LLVMOpaqueValue* ir_render_cast(CodeGen*, IrExecutable*, IrInstructionCast*): Assertion `expr_val' failed.
    //  Aborted (core dumped)
    //assert(misc.nonInfMinValue(u0) == saturateCast(u0, misc.minValue(f64)));
    //assert(misc.nonInfMinValue(u0) == saturateCast(u0, misc.nonInfMinValue(f64)));
    //assert(0 == saturateCast(u0, f64(-0.0)));
    //assert(0 == saturateCast(u0, f64(0.0)));
    //assert(0 == saturateCast(u0, f64(1)));
    //assert(0 == saturateCast(u0, f64(1123)));
    //assert(0 == saturateCast(i32, f64(1123.9)));
    //assert(misc.nonInfMaxValue(u0) == saturateCast(u0, misc.nonInfMaxValue(f64)));
    //assert(misc.nonInfMaxValue(u0) == saturateCast(u0, misc.maxValue(f64)));

    assert(nonInfMinValue(u1) == saturateCast(u1, minValue(f64)));
    assert(nonInfMinValue(u1) == saturateCast(u1, nonInfMinValue(f64)));
    assert(0 == saturateCast(u1, f64(-0.0)));
    assert(0 == saturateCast(u1, f64(0.0)));
    assert(1 == saturateCast(u1, f64(1)));
    assert(1 == saturateCast(u1, f64(1123)));
    assert(1 == saturateCast(u1, f64(1123.9)));
    assert(nonInfMaxValue(u1) == saturateCast(u1, nonInfMaxValue(f64)));
    assert(nonInfMaxValue(u1) == saturateCast(u1, maxValue(f64)));

    assert(nonInfMinValue(u32) == saturateCast(u32, minValue(f64)));
    assert(nonInfMinValue(u32) == saturateCast(u32, nonInfMinValue(f64)));
    assert(0 == saturateCast(u32, f64(-0.0)));
    assert(0 == saturateCast(u32, f64(0.0)));
    assert(1 == saturateCast(u32, f64(1)));
    assert(1123 == saturateCast(u32, f64(1123)));
    assert(nonInfMaxValue(u32) == saturateCast(u32, nonInfMaxValue(f64)));
    assert(nonInfMaxValue(u32) == saturateCast(u32, maxValue(f64)));

    assert(nonInfMinValue(u128) == saturateCast(u128, minValue(f64)));
    assert(nonInfMinValue(u128) == saturateCast(u128, nonInfMinValue(f64)));
    assert(0 == saturateCast(u128, f64(-0.0)));
    assert(0 == saturateCast(u128, f64(0.0)));
    assert(1 == saturateCast(u128, f64(1)));
    assert(1123 == saturateCast(u128, f64(1123)));
    assert(nonInfMaxValue(u128) == saturateCast(u128, nonInfMaxValue(f64)));
    assert(nonInfMaxValue(u128) == saturateCast(u128, maxValue(f64)));
}
