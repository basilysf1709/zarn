const std = @import("std");
const commands = @import("commands.zig");

pub fn run(allocator: std.mem.Allocator) !void {
    var args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        try printUsage();
        return;
    }

    const command = args[1];
    if (std.mem.eql(u8, command, "install")) {
        try commands.install(allocator, args[2..]);
    } else if (std.mem.eql(u8, command, "init")) {
        try commands.init(allocator);
    } else {
        std.debug.print("Unknown command: {s}\n", .{command});
        try printUsage();
    }
}

fn printUsage() !void {
    try std.io.getStdOut().writer().print(
        \\Usage: zarn <command> [options]
        \\
        \\Commands:
        \\  install    Install packages
        \\  init       Initialize a new project
        \\
    , .{});
}
