//! FLib.IO.Directory
//! Author : farey0
//!
//! std's directory functions but in upper camel case

//                               ----------------   Declarations   ----------------

const Self = @This();

const File = @import("File.zig");

const fs = @import("std").fs;

pub const OpenError = fs.Dir.OpenError;

pub const OpenOptions = fs.Dir.OpenDirOptions;

//                               ----------------      Members     ----------------

stdDir: fs.Dir = undefined,

//                               ----------------      Public      ----------------

pub fn Open(path: []const u8, options: OpenOptions) OpenError!Self {
    return .{ .stdDir = try fs.openDirAbsolute(path, options) };
}

pub fn OpenRelative(path: []const u8, options: OpenOptions) OpenError!Self {
    return .{ .stdDir = try fs.cwd().openDir(path, options) };
}

pub fn OpenFile(self: Self, path: []const u8, options: File.OpenOptions) File.OpenError!File {
    return .{ .stdFile = try self.stdDir.openFile(path, options) };
}

pub fn Close(self: *Self) void {
    self.stdDir.close();
}
