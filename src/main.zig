const std = @import("std");
const print = std.debug.print;
const bblsrt = @import("bubble_sort.zig");

const RndGen = std.Random.DefaultPrng;

pub fn main() void {
    var rnd = RndGen.init(@truncate(std.time.nanoTimestamp()));
    const len = 20;
    var arr: [len]u32 = .{0} ** len;
    for (0..len) |i| {
        arr[i] = rnd.random().intRangeLessThan(u32, 0, 150);
    }

    printArr(arr[0..]);

    bblsrt.sort(arr[0..]);

    printArr(arr[0..]);
}

fn printArr(arr: []u32) void {
    for (arr) |el| {
        print("{d:>3} ", .{el});
    }
    print("\n", .{});
}
