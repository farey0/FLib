//! FLib
//! Author : farey0

pub const Allocator = @import("Allocator/Allocator.zig");
pub const IO = @import("IO/IO.zig");
pub const Memory = @import("Memory.zig");
pub const Reflection = @import("Reflection.zig");
pub const Console = @import("Console.zig");
pub const Collections = @import("Collections/Collections.zig");
pub const Mutex = @import("Mutex.zig");
pub const Testing = @import("Testing.zig");

test {
    @import("std").testing.refAllDecls(@This());
}
