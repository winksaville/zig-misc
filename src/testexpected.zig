const std = @import("std");
const io = std.io;
const File = std.os.File;
const assert = std.debug.assert;

/// Test if two slices are equal. If not print the contents of the
/// expected and actual strings to out_stream and return false.
pub fn testExpectedStream(comptime Error: type, out_stream: *io.OutStream(Error), expected: []const u8, actual: []const u8) bool {
    if (std.mem.eql(u8, expected, actual)) return true;

    out_stream.print("\n====== expected this output: =========\n") catch {};
    out_stream.print("{}", expected) catch {};
    out_stream.print("\n======== instead found this: =========\n") catch {};
    out_stream.print("{}", actual) catch {};
    out_stream.print("\n======================================\n") catch {};
    return false;
}

/// Test if two slices are equal. If not print the contents of the
/// expected and actual strings to stderr and return false.
pub fn testExpected(expected: []const u8, actual: []const u8) bool {
    var st = std.debug.getStderrStream() catch return false;
    return testExpectedStream(std.os.File.WriteError, st, expected, actual);
}

test "testExpectedError" {
    var bytes: [256]u8 = undefined;
    var allocator = &std.heap.FixedBufferAllocator.init(bytes[0..]).allocator;

    var buffer = try std.Buffer.initSize(allocator, 0);
    var buf_stream = &std.io.BufferOutStream.init(&buffer).stream;
    assert(!testExpectedStream(std.io.BufferOutStream.Error, buf_stream, "abd", "abc"));
    assert(std.mem.eql(u8, buffer.toSlice(),
            \\
            \\====== expected this output: =========
            \\abd
            \\======== instead found this: =========
            \\abc
            \\======================================
            \\
    ) );
}

test "testExpected" {
    assert(testExpected("abc", "abc"));
}

