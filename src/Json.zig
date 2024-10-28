//! FLib.Json
//! Author : farey0
//!
//! Wrapper around std's json functions in upper camel case

//                               ----------------   Declarations   ----------------

const std = @import("std");
const Json = std.json;

const Allocator = @import("Allocator/Allocator.zig");
const Interface = Allocator.Interface;

//                               ----------------      Public      ----------------

pub const ParseError = Json.ParseError(Json.Scanner);
pub const ParseOptions = Json.ParseOptions;

pub fn Parse(comptime T: type, allocInterface: Interface, content: []const u8, options: ParseOptions) ParseError!struct { data: T, arena: Allocator.Arena } {
    var scanner = Json.Scanner.initCompleteInput(allocInterface.ToStd(), content);
    defer scanner.deinit();

    var arena: Allocator.Arena = Allocator.Arena.Init(allocInterface);

    errdefer arena.DeInit();

    return .{
        .data = try Json.parseFromTokenSourceLeaky(T, arena.GetInterface().ToStd(), &scanner, options),
        .arena = arena,
    };
}
