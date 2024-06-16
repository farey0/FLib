//! FLib
//! Author : farey0
//!
//!

// ---------------- Imports

const std = @import("std");
const Mutex = @import("Mutex.zig");

const Self = @This();

// ---------------- Members

var data: struct {
    stdOut: std.fs.File.Writer = std.io.getStdOut().writer(),
    stdOutLock: Mutex = .{},
} = .{};

// ---------------- Public

pub fn Print(comptime format: []const u8, args: anytype) void {
    data.stdOutLock.Lock();
    defer data.stdOutLock.Unlock();

    data.stdOut.print(format, args) catch unreachable;
}

pub fn PrintLine(comptime format: []const u8, args: anytype) void {
    data.stdOutLock.Lock();
    defer data.stdOutLock.Unlock();

    data.stdOut.print(format ++ "\n", args) catch unreachable;
}

pub fn Write(comptime toWrite: []const u8) !void {
    data.stdOutLock.Lock();
    defer data.stdOutLock.Unlock();

    data.stdOut.write(toWrite) catch unreachable;
}

pub fn WriteLine(comptime toWrite: []const u8) !void {
    data.stdOutLock.Lock();
    defer data.stdOutLock.Unlock();

    data.stdOut.write(toWrite) catch unreachable;
    data.stdOut.write("\n") catch unreachable;
}
