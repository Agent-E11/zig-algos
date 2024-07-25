const std = @import("std");
const testing = std.testing;

pub const bubble_sort = @import("bubble_sort.zig");
pub const array_list = @import("array_list.zig");

export fn add(a: i32, b: i32) i32 {
    return a + b;
}

test {
    std.testing.refAllDecls(@This());
}

test "basic add functionality" {
    try testing.expect(add(3, 7) == 10);
}
