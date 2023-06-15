const std = @import("std");
const mach = @import("libs/mach/build.zig");

pub fn build(b: *std.Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // mach-ggml module
    const ggml = b.addModule("mach-ggml", .{
        .source_file = .{ .path = "src/main.zig" },
        .dependencies = &[_]std.build.ModuleDependency{.{
            .name = "mach",
            .module = mach.module(b, optimize, target),
        }},
    });

    // Example application
    const example_app = try mach.App.init(b, .{
        .name = "ggml-example",
        .src = "example/main.zig",
        .target = target,
        .deps = &[_]std.build.ModuleDependency{.{
            .name = "mach-ggml",
            .module = ggml,
        }},
        .optimize = optimize,
    });
    try example_app.link(.{});
    example_app.install();

    const run_cmd = example_app.addRunArtifact();
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the example");
    run_step.dependOn(&run_cmd.step);
}
