const std = @import("std");
const print = std.debug.print;
const Allocator = std.mem.Allocator;
const DefaultAllocator = std.heap.ArenaAllocator;

/// Calculate a new capacity using the current capacity and a scale.
/// Equivalent to `new = current * scale` but also does the appropriate type conversions.
fn calculateNewCapacity(current: usize, scale: f32) usize {
    return @intFromFloat(@ceil(@as(f32, @floatFromInt(current)) * scale));
}

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
            if (self.len + 1 > self.items.len) {
                var new_items = try Self.allocator.alloc(T, calculateNewCapacity(self.items.len, Self.alloc_factor));

                for (self.items, 1..) |old_item, i| {
                    new_items[i] = old_item;
                }
                //const old_items = self.items;
                self.items = new_items; // FIXME: Will I need to free this eventually?
                //Self.allocator.free(old_items);

                // Prepend item
                self.items[0] = item;
                self.len += 1;
                return;
            }
            // Shift all items one over
            var i = self.len;
            while (i > 0) : (i -= 1) {
                self.items[i] = self.items[i - 1];
            }

            // Prepend item
            self.items[0] = item;
            self.len += 1;
        }

        pub fn append(self: *Self, item: T) !void {
            if (self.len + 1 > self.items.len) {
                var new_items = try Self.allocator.alloc(T, calculateNewCapacity(self.items.len, Self.alloc_factor));

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

    // Allocate more
    try l.append(11);
    try expect(l.get(3) == 11);

    print("capacity: {}\n", .{l.items.len});
    print("items: ", .{});
    for (0..l.len) |i| {
        print("{d} ", .{l.get(i)});
    }
    print("\n", .{});

    try l.prepend(3);
    try l.prepend(1);

    try expect(l.get(0) == 1);
    try expect(l.get(1) == 3);

    print("capacity: {}\n", .{l.items.len});
    print("items: ", .{});
    for (0..l.len) |i| {
        print("{d} ", .{l.get(i)});
    }
    print("\n", .{});
}
