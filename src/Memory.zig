//! FLib.Memory
//! Author : farey0
//!
//! Compare and swap

pub inline fn Compare(comptime Type: type, a: []const Type, b: []const Type) bool {
    return @import("std").mem.eql(Type, a, b);
}

pub inline fn Swap(comptime T: type, a: *T, b: *T) void {
    const c: T = a.*;
    a.* = b.*;
    b.* = c;
}
