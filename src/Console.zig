//! FLib.Console
//! Author : farey0
//!
//! Wrapper around std's console functions.
//! You need to call Init() once before using any other functions.

// ---------------- Imports

const std = @import("std");
const Mutex = @import("Mutex.zig");

const Self = @This();

// ---------------- Members

var data: struct {
    stdOut: std.fs.File.Writer,
    stdOutLock: Mutex = .{},
} = undefined;

// ---------------- Public

pub fn Init() void {
    data = .{ .stdOut = std.io.getStdOut().writer() };
}

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

pub fn Write(toWrite: []const u8) void {
    data.stdOutLock.Lock();
    defer data.stdOutLock.Unlock();

    var i: usize = 0;

    while (i < toWrite.len) {
        i += data.stdOut.write(toWrite[i..]) catch unreachable;
    }
}

pub fn WriteLine(toWrite: []const u8) void {
    data.stdOutLock.Lock();
    defer data.stdOutLock.Unlock();

    const newLine = "\n";

    var i: usize = 0;

    while (i < toWrite.len) {
        i += data.stdOut.write(toWrite[i..]) catch unreachable;
    }

    i = 0;

    while (i < newLine.len) {
        i += data.stdOut.write(newLine[i..]) catch unreachable;
    }
}
