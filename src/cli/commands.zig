const std = @import("std");
const Builder = @import("../build/builder.zig").Builder;
const Package = @import("../package/package.zig").Package;

pub fn install(allocator: std.mem.Allocator, args: []const []const u8) !void {
    std.debug.print("Installing packages: {s}\n", .{args});
    var builder = try Builder.init(allocator);
    defer builder.deinit();
    try builder.buildDependencies();
}

pub fn init(allocator: std.mem.Allocator) !void {
    const stdout = std.io.getStdOut().writer();

    try stdout.print("Initializing new project\n", .{});

    const name = try prompt(allocator, "Project name: ");
    defer allocator.free(name);

    const version = try prompt(allocator, "Version (0.1.0): ");
    defer allocator.free(version);

    var package = try Package.init(allocator, name, if (version.len > 0) version else "0.1.0");
    defer package.deinit();

    try stdout.print("Created package: {s} v{s}\n", .{ package.name, package.version });

    // Write package info to zarn.toml
    const file = try std.fs.cwd().createFile("zarn.toml", .{});
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
