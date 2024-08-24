const std = @import("std");
const commands = @import("commands.zig");

pub fn run(allocator: std.mem.Allocator, test_name: ?[]const u8, test_version: ?[]const u8) !void {
    std.debug.print("Entering run function\n", .{});

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    std.debug.print("Args allocated: {any}\n", .{args});

    if (args.len < 2 and test_name == null) {
        std.debug.print("Insufficient args, printing usage\n", .{});
        try printUsage();
        return;
    }

    const command = if (test_name == null) args[1] else "init";
    std.debug.print("Command: {s}\n", .{command});

    if (std.mem.eql(u8, command, "init")) {
        std.debug.print("Executing init command\n", .{});
        const name = test_name orelse if (args.len > 2) args[2] else try prompt(allocator, "Project name: ");
        std.debug.print("Project name: {s}\n", .{name});
        const version = test_version orelse if (args.len > 3) args[3] else try prompt(allocator, "Version (0.1.0): ");
        std.debug.print("Version: {s}\n", .{version});
        std.debug.print("Calling commands.init\n", .{});
        try commands.init(allocator, std.fs.cwd(), name, version);
        std.debug.print("commands.init completed\n", .{});
    } else {
        std.debug.print("Unknown command: {s}\n", .{command});
        try printUsage();
    }

    std.debug.print("Exiting run function\n", .{});
}

fn printUsage() !void {
    std.debug.print("Printing usage\n", .{});
    try std.io.getStdOut().writer().print(
        \\Usage: zarn <command> [options]
        \\
        \\Commands:
        \\  init       Initialize a new project
        \\
    , .{});
}

fn prompt(allocator: std.mem.Allocator, message: []const u8) ![]const u8 {
    std.debug.print("Prompting: {s}\n", .{message});
    const stdout = std.io.getStdOut().writer();
    try stdout.print("{s}", .{message});

    var buf: [1024]u8 = undefined;
    const stdin = std.io.getStdIn().reader();
    if (try stdin.readUntilDelimiterOrEof(buf[0..], '\n')) |user_input| {
        std.debug.print("User input: {s}\n", .{user_input});
        return allocator.dupe(u8, user_input);
    }
    std.debug.print("No user input, returning empty string\n", .{});
    return allocator.dupe(u8, "");
}
