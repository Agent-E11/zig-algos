const std = @import("std");
const print = std.debug.print;
const Allocator = std.mem.Allocator;
const DefaultAllocator = std.heap.ArenaAllocator;

pub fn ArrayList(comptime T: type) type {
    return struct {
        len: usize,
        items: []T,
        capacity: usize, // TODO: Remove this and use items.len

        const Self = @This();
        var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
        const allocator = arena.allocator();
        const alloc_factor = 1.25;

        pub fn init(init_cap: usize) !Self {
            print("initializing...\n", .{});
            const items = try Self.allocator.alloc(T, init_cap);
            print("items.len: {}\n", .{items.len});
            const cap = init_cap;
            print("capacity: {}\n", .{cap});
            const init_len: usize = 0;
            print("init_len: {}\n", .{init_len});
            return Self{
                .len = init_len,
                .items = items,
                .capacity = cap,
            };
        }

        pub fn length(self: Self) usize {
            return self.len;
        }

        pub fn prepend(self: Self, item: T) void {
            _ = self;
            _ = item;
        }

        pub fn append(self: *Self, item: T) !void {
            print("appending {}...\n", .{item});
            print("items.len: {}\n", .{self.items.len});
            print("self.len: {}\n", .{self.len});
            if (self.len + 1 > self.capacity) {
                print("allocating more space...\n", .{});
                const new_capacity: usize = @intFromFloat(@ceil(@as(f32, @floatFromInt(self.capacity)) * Self.alloc_factor));
                print("old capacity: {}\n", .{self.capacity});
                print("new capacity: {}\n", .{new_capacity});
                var new_items = try Self.allocator.alloc(T, new_capacity);
                print("new_items.len: {}\n", .{new_items.len});
                print("self.len: {}\n", .{self.len});

                for (self.items, 0..) |old_item, i| new_items[i] = old_item;
                self.items = new_items;
                self.capacity = new_capacity;
            }

            self.items[self.len] = item;
            self.len += 1;
            print("incrementing self.len: {}\n", .{self.len});

            print("at the end of append {}\n", .{item});
            //print("items.len: {}\n", .{self.items.len});
            print("self.len: {}\n", .{self.len});
        }

        pub fn insertAt(self: Self, item: T, idx: usize) void {
            _ = self;
            _ = item;
            _ = idx;
        }

        pub fn remove(self: Self, item: T) ?T {
            _ = self;
            _ = item;
            return;
        }

        pub fn get(self: Self, idx: usize) ?T {
            if (idx < 0 or idx >= self.len) return null;

            return self.items[idx];
        }

        pub fn removeAt(self: Self, idx: usize) ?T {
            _ = self;
            _ = idx;
            return;
        }
    };
}

const expect = std.testing.expect;

test "test array list" {
    var l = try ArrayList(u8).init(3);
    try l.append(5);
    print("l.len after 5: {}\n", .{l.len});
    try l.append(7);
    print("l.len after 7: {}\n", .{l.len});
    try l.append(9);
    print("l.len after 9: {}\n", .{l.len});

    try expect(l.get(0) == 5);
    try expect(l.get(1) == 7);
    try expect(l.get(2) == 9);

    try l.append(10);
    try expect(l.get(3) == 10);

    print("capacity: {d}\n", .{l.capacity});
    print("length: {d}\n", .{l.len});
    print("items:\n", .{});
    for (l.items) |item| {
        print("{d} ", .{item});
    }
}
