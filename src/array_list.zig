const std = @import("std");
const print = std.debug.print;
const Allocator = std.mem.Allocator;
const DefaultAllocator = std.heap.ArenaAllocator;

pub fn ArrayList(comptime T: type) type {
    return struct {
        len: usize,
        items: []T,

        const Self = @This();
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        const allocator = arena.allocator();
        const alloc_factor = 1.25;

        pub fn init(init_cap: usize) !Self {
            return Self{
                .len = 0,
                .items = try Self.allocator.alloc(T, init_cap),
            };
        }

        pub fn length(self: Self) usize {
            return self.len; // TODO: Do I even need this?
        }

        pub fn prepend(self: *Self, item: T) !void {
            _ = self;
            _ = item;
            unreachable;
        }

        pub fn append(self: *Self, item: T) !void {
            if (self.len + 1 > self.items.len) {
                const new_capacity: usize = @intFromFloat(@ceil(@as(f32, @floatFromInt(self.items.len)) * Self.alloc_factor));
                var new_items = try Self.allocator.alloc(T, new_capacity);

                for (self.items, 0..) |old_item, i| new_items[i] = old_item;
                //const old_items = self.items;
                self.items = new_items; // FIXME: Will I need to free this eventually?
                //Self.allocator.free(old_items);
            }

            self.items[self.len] = item;
            self.len += 1;
        }

        pub fn insertAt(self: Self, item: T, idx: usize) void {
            _ = self;
            _ = item;
            _ = idx;
            unreachable;
        }

        pub fn remove(self: Self, item: T) ?T {
            _ = self;
            _ = item;
            unreachable;
        }

        pub fn get(self: Self, idx: usize) ?T {
            if (idx < 0 or idx >= self.len) return null;

            return self.items[idx];
        }

        pub fn removeAt(self: Self, idx: usize) ?T {
            _ = self;
            _ = idx;
            unreachable;
        }
    };
}

const expect = std.testing.expect;

test "test array list" {
    var l = try ArrayList(u8).init(3);
    try l.append(5);
    try l.append(7);
    try l.append(9);

    try expect(l.get(0) == 5);
    try expect(l.get(1) == 7);
    try expect(l.get(2) == 9);

    try l.append(10);
    try expect(l.get(3) == 10);

    //print("items:\n", .{});
    //for (l.items) |item| {
    //print("{d} ", .{item});
    //}
}
