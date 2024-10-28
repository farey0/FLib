//! FLib.Allocator
//! Author : farey0
//!
//! Interface to a std allocator

//                               ----------------   Declarations   ----------------

const std = @import("std");

const Self = @This();

pub const Error = error{OutOfMemory};

pub const PageAllocator: Self = .{
    .stdAllocator = std.heap.page_allocator,
};

//                              ----------------      Members     ----------------

stdAllocator: std.mem.Allocator = undefined,

//                              ----------------      Public      ----------------

pub fn AllocateArray(self: Self, comptime Type: type, size: usize) Error![]Type {
    return try self.stdAllocator.alloc(Type, size);
}

pub fn AllocateOne(self: Self, comptime Type: type) Error!*Type {
    return try self.stdAllocator.create(Type);
}

pub fn Reallocate(self: Self, pointer: anytype, size: usize) t: {
    const Slice = @typeInfo(@TypeOf(pointer)).Pointer;
    break :t Error![]align(Slice.alignment) Slice.child;
} {
    return try self.stdAllocator.realloc(pointer, size);
}

pub fn FreeArray(self: Self, array: anytype) void {
    self.stdAllocator.free(array);
}

pub fn FreeOne(self: Self, pointer: anytype) void {
    self.stdAllocator.destroy(pointer);
}

pub fn FromStd(stdAllocator: std.mem.Allocator) Self {
    return .{ .stdAllocator = stdAllocator };
}

pub fn ToStd(self: Self) std.mem.Allocator {
    return self.stdAllocator;
}
