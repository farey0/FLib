//! FLib.Collections.ArrayList
//! Author : farey0
//!
//! Basic array structure

pub fn ArrayList(comptime T: type, comptime InitialSize: usize, comptime GrowthFactor: f32) type {
    return struct {

        //                          ----------------   Declarations   ----------------

        const Self = @This();

        const Memory = @import("../Memory.zig");
        const Allocator = @import("../Allocator/Allocator.zig");
        const Interface = Allocator.Interface;

        //                          ----------------      Members     ----------------

        allocator: Allocator.Interface = undefined,
        data: []T = undefined,
        currSize: usize = undefined,

        //                          ----------------      Public      ----------------

        pub fn Init(allocator: Allocator.Interface) Interface.Error!Self {
            var out: Self = .{
                .allocator = allocator,
                .currSize = 0,
            };

            if (InitialSize != 0) {
                out.data = try allocator.AllocateArray(T, InitialSize);
            } else {
                out.data.len = 0;
            }

            return out;
        }

        pub fn DeInit(self: *Self) void {
            self.allocator.FreeArray(self.data);
        }

        pub fn GrowSuperiorTo(self: *Self, to: usize) Interface.Error!void {
            var finalSize: usize = if (self.data.len == 0) 1 else self.data.len;

            while (finalSize < to)
                finalSize = MultiplyAlwaysSuperior(finalSize, GrowthFactor);

            if (self.data.len != 0)
                self.data = try self.allocator.Reallocate(self.data, finalSize)
            else
                self.data = try self.allocator.AllocateArray(T, finalSize);
        }

        pub fn Append(self: *Self, item: T) Interface.Error!void {
            if (self.currSize + 1 == self.data.len) {
                try self.GrowSuperiorTo(self.data.len + 1);
            }

            self.data[self.currSize] = item;
            self.currSize += 1;
        }

        pub fn AppendSlice(self: *Self, items: []T) Interface.Error!void {
            const slice = try self.AllocateSlice(items.len);

            @memcpy(slice, items);
        }

        pub fn AllocateSlice(self: *Self, size: usize) Interface.Error![]T {
            const oldSize = self.GetSize();

            try self.GrowSuperiorTo(oldSize + size);

            self.currSize += size;

            return self.data[oldSize .. oldSize + size];
        }

        pub fn AllocateOne(self: *Self) Interface.Error!*T {
            return &((try self.AllocateSlice(1))[0]);
        }

        pub fn RemoveAndSwap(self: *Self, index: usize) void {
            if (index >= self.currSize)
                return;

            self.currSize -= 1;

            @import("../Memory.zig").Swap(T, self.data[index], self.data[self.currSize]);
        }

        //                          ------------- Public Getters/Setters -------------

        pub fn GetCapacity(self: Self) usize {
            return self.data.len;
        }

        pub fn GetSlice(self: Self) []T {
            return self.data[0..self.GetSize()];
        }

        pub fn GetSize(self: Self) usize {
            return self.currSize;
        }

        //                          ----------------      Private     ----------------

        fn MultiplyAlwaysSuperior(with: usize, by: f32) usize {
            const ret: usize = @intFromFloat(@as(f64, @floatFromInt(with)) * by);

            return if (ret == with) ret + 1 else ret;
        }
    };
}
