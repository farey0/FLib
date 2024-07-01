//! FLib.Allocaor
//! Author : farey0

const std = @import("std");

pub const Interface = @import("Interface.zig");

pub const GeneralPurpose = struct {
    // ---------------- Declarations

    const Self = @This();

    // ---------------- Members

    internal: @TypeOf(std.heap.GeneralPurposeAllocator(.{}){}),

    // ---------------- Public

    pub fn Init() Self {
        return .{ .internal = std.heap.GeneralPurposeAllocator(.{}){} };
    }

    pub fn DeInit(self: *Self) void {
        if (self.internal.deinit() == std.heap.Check.leak)
            _ = self.internal.detectLeaks();
    }

    pub fn GetInterface(self: *Self) Interface {
        return .{ .stdAllocator = self.internal.allocator() };
    }
};
