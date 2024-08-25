const std = @import("std");
const cli = @import("cli/cli.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const cwd = std.fs.cwd();
    try cli.run(allocator, cwd, "zarn_test", "1.0.0");
}
