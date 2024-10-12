//! FLib.Memory
//! Author : farey0
//!
//! Compare and swap

pub inline fn Compare(comptime Type: type, a: []const Type, b: []const Type) bool {
    if (a.len != b.len) return false;
    if (a.ptr == b.ptr) return true;

    for (a, b) |a_elem, b_elem| {
        if (a_elem != b_elem) return false;
    }

    return true;
}

pub inline fn InlineCompare(comptime Type: type, comptime Size: usize, a: [Size]Type, b: [Size]Type) bool {
    inline for (a, b) |a_elem, b_elem| {
        if (a_elem != b_elem) return false;
    }

    return true;
}

pub inline fn Swap(comptime T: type, a: *T, b: *T) void {
    const c: T = a.*;
    a.* = b.*;
    b.* = c;
}
