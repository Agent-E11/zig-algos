const std = @import("std");

pub fn sort(arr: []u32) void {
    var sorted = false;
    while (!sorted) {
        sorted = true;
        for (1..arr.len) |i| {
            if (arr[i - 1] > arr[i]) {
                swap(&arr[i - 1], &arr[i]);
                sorted = false;
            }
        }
    }
}

fn swap(x: *u32, y: *u32) void {
    const tmp = x.*;
    x.* = y.*;
    y.* = tmp;
}

test "sort array" {
    const eql = std.mem.eql;

    var arr: [5]u32 = .{ 4, 2, 3, 5, 1 };

    const expect: [5]u32 = .{ 1, 2, 3, 4, 5 };

    sort(arr[0..]);
    try std.testing.expect(eql(u32, arr[0..], expect[0..]));
}
