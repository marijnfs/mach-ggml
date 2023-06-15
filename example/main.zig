const std = @import("std");
const mach = @import("mach");
const gpu = mach.gpu;
const ggml = @import("mach-ggml");

pub const App = @This();

var gpa = std.heap.GeneralPurposeAllocator(.{}){};

core: mach.Core,

pub fn init(app: *App) !void {
    try app.core.init(gpa.allocator(), .{});
    const results = try ggml.compute(gpa.allocator(), &app.core);
    _ = results;
}

pub fn deinit(app: *App) void {
    defer _ = gpa.deinit();
    defer app.core.deinit();
}

pub fn update(app: *App) !bool {
    _ = app;
    return true; // exit the app after the first frame has run
}
