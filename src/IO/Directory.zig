//! FLib.IO.Directory
//! Author : farey0
//!
//! std's directory functions but in upper camel case

//                               ----------------   Declarations   ----------------

const Self = @This();

const File = @import("File.zig");

const fs = @import("std").fs;

pub const OpenError = fs.Dir.OpenError;
pub const CreateError = fs.Dir.MakeError;

pub const OpenOptions = fs.Dir.OpenDirOptions;

//                               ----------------      Members     ----------------

stdDir: fs.Dir = undefined,

//                               ----------------      Public      ----------------

pub fn Open(path: []const u8, options: OpenOptions) OpenError!Self {
    return .{ .stdDir = try fs.openDirAbsolute(path, options) };
}

// Don't close it. Cannot iterate over it. Call GetCwd().OpenRelative(".", ) to iterate over it
pub fn GetCwd() Self {
    return .{ .stdDir = fs.cwd() };
}

pub fn OpenRelative(self: Self, path: []const u8, options: OpenOptions) OpenError!Self {
    return .{ .stdDir = try self.stdDir.openDir(path, options) };
}

pub fn OpenFile(self: Self, path: []const u8, options: File.OpenOptions) File.OpenError!File {
    return .{ .stdFile = try self.stdDir.openFile(path, options) };
}

pub fn CreateFile(self: Self, path: []const u8, options: File.CreateOptions) File.OpenError!File {
    return .{ .stdFile = try self.stdDir.createFile(path, options) };
}

pub fn CreateRelative(self: Self, path: []const u8) CreateError!void {
    try self.stdDir.makeDir(path);
}

pub fn SetAsCwd(self: Self) !void {
    try self.stdDir.setAsCwd();
}

pub fn Close(self: *Self) void {
    self.stdDir.close();
}
