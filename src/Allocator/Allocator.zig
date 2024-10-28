//! FLib.Allocator
//! Author : farey0
//!
//! Wraps around allocators from std
//!
//! TODO: Add binned allocator : https://gist.github.com/silversquirl/c1e4840048fdf48e669b6eac76d80634

const std = @import("std");

pub const Interface = @import("Interface.zig");

pub const GeneralPurpose = struct {
    // ---------------- Declarations

    const Self = @This();

    // ---------------- Members

    internal: @TypeOf(std.heap.GeneralPurposeAllocator(.{}){}) = undefined,

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

pub const Arena = struct {

    // ---------------- Declarations

    const Self = @This();

    // ---------------- Members

    internal: std.heap.ArenaAllocator = undefined,

    // ---------------- Public

    pub fn Init(childAllocator: Interface) Self {
        return .{ .internal = std.heap.ArenaAllocator.init(childAllocator.ToStd()) };
    }

    pub fn DeInit(self: Self) void {
        self.internal.deinit();
    }

    pub fn GetInterface(self: *Self) Interface {
        return Interface.FromStd(self.internal.allocator());
    }
};

pub const FixedBuffer = struct {

    // ---------------- Declarations

    const Self = @This();

    // ---------------- Members

    internal: std.heap.FixedBufferAllocator = undefined,

    // ---------------- Public

    pub fn Init(buffer: []u8) Self {
        return .{ .internal = std.heap.FixedBufferAllocator.init(buffer) };
    }

    pub fn DeInit(self: Self) void {
        self.internal.deinit();
    }

    pub fn GetInterface(self: Self) Interface {
        return Interface.FromStd(self.internal.allocator());
    }
};
