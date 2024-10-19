//! FLib
//! Author : farey0

const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const FLib = b.addModule("FLib", .{
        .root_source_file = b.path("src/FLib.zig"),
        .target = target,
        .optimize = optimize,
    });

    _ = FLib;

    const FLibUnitTests = b.addTest(.{
        .root_source_file = b.path("src/FLib.zig"),
        .target = target,
        .optimize = optimize,
    });
    const UnitTestRun = b.addRunArtifact(FLibUnitTests);

    const TestStep = b.step("test", "Run unit tests");
    TestStep.dependOn(&UnitTestRun.step);
}
