const std = @import("std");
const Package = @import("package").Package;

pub fn init(allocator: std.mem.Allocator, dir: std.fs.Dir, name: []const u8, version: []const u8) !void {
    const stdout = std.io.getStdOut().writer();

    try stdout.print("Initializing new project\n", .{});

    var package = try Package.init(allocator, name, if (version.len > 0) version else "0.1.0");
    defer package.deinit();

    try stdout.print("Created package: {s} v{s}\n", .{ package.name, package.version });

    // Write package info to zarn.toml in the specified directory
    const file = try dir.createFile("zarn.toml", .{});
    defer file.close();

    const writer = file.writer();
    try writer.print(
        \\[package]
        \\name = "{s}"
        \\version = "{s}"
        \\
    , .{ package.name, package.version });

    try stdout.print("Created zarn.toml file\n", .{});
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
