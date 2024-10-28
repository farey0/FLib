//! FLib.IO.File
//! Author : farey0
//!
//! std's file functions but in upper camel case

//                               ----------------   Declarations   ----------------

const Self = @This();

const fs = @import("std").fs;

const Interface = @import("../Allocator/Interface.zig");

//                              ----------------      Members     ----------------

stdFile: fs.File = undefined,

pub const OpenError = fs.File.OpenError;
pub const SeekError = fs.File.GetSeekPosError;
pub const ReadError = fs.File.ReadError;
pub const WriteError = fs.File.WriteError;

pub const OpenOptions = fs.File.OpenFlags;
pub const CreateOptions = fs.File.CreateFlags;

//                              ----------------      Public      ----------------

pub fn Open(path: []const u8, options: OpenOptions) OpenError!Self {
    return .{ .stdFile = try fs.openFileAbsolute(path, options) };
}

pub fn OpenRelative(path: []const u8, options: OpenOptions) OpenError!Self {
    return .{ .stdFile = try fs.cwd().openFile(path, options) };
}

pub fn Close(self: *Self) void {
    self.stdFile.close();
}

pub fn GetSize(self: Self) SeekError!u64 {
    return try self.stdFile.getEndPos();
}

pub fn ReadAll(self: Self, allocator: Interface) (error{OutOfMemory} || ReadError || SeekError)![]u8 {
    const fileSize = try self.GetSize();

    const out: []u8 = try allocator.AllocateArray(u8, @intCast(fileSize));

    _ = try self.stdFile.readAll(out);

    return out;
}

pub fn WriteAll(self: Self, data: []const u8) WriteError!void {
    try self.stdFile.writeAll(data);
}

//                              ---------------- Getters/Setters  ----------------

//                              ----------------      Private     ----------------
