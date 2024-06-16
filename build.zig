//! FLib
//! Author : farey0

const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const FLib = b.addModule("FLib", .{
        .root_source_file = .{ .cwd_relative = "src/FLib.zig" },
        .target = target,
        .optimize = optimize,
    });

    _ = FLib;

    const FKernelUnitTests = b.addTest(.{
        .root_source_file = .{ .cwd_relative = "src/FLib.zig" },
        .target = target,
        .optimize = optimize,
    });
    const UnitTestRun = b.addRunArtifact(FKernelUnitTests);

    const TestStep = b.step("test", "Run unit tests");
    TestStep.dependOn(&UnitTestRun.step);
}