const std = @import("std");
const commands = @import("commands.zig");

pub fn run(allocator: std.mem.Allocator, working_dir: std.fs.Dir, test_name: ?[]const u8, test_version: ?[]const u8) !void {
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len < 2 and test_name == null) {
        try printUsage();
        return;
    }

    const command = if (test_name == null) args[1] else "init";

    if (std.mem.eql(u8, command, "init")) {
        const name = test_name orelse if (args.len > 2) args[2] else try prompt(allocator, "Project name: ");
        const version = test_version orelse if (args.len > 3) args[3] else try prompt(allocator, "Version (0.1.0): ");
        try commands.init(allocator, working_dir, name, version);
    } else {
        try printUsage();
    }
}

fn printUsage() !void {
    try std.io.getStdOut().writer().print(
        \\Usage: zarn <command> [options]
        \\
        \\Commands:
        \\  init       Initialize a new project
        \\
    , .{});
}

fn prompt(allocator: std.mem.Allocator, message: []const u8) ![]const u8 {
    const stdout = std.io.getStdOut().writer();
    try stdout.print("{s}", .{message});

    var buf: [1024]u8 = undefined;
    const stdin = std.io.getStdIn().reader();
    if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |user_input| {
        return allocator.dupe(u8, user_input);
    }
    return allocator.dupe(u8, "");
}
