const std = @import("std");
const cli = @import("cli");
const fs = std.fs;

test "zarn init command" {
    std.debug.print("Starting test\n", .{});

    var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    // Create a temporary directory for testing
    var tmp_dir = std.testing.tmpDir(.{});
    defer tmp_dir.cleanup();

    std.debug.print("Running cli.run\n", .{});
    try cli.run(allocator, "test_project", "1.0.0");

    std.debug.print("Checking for zarn.toml\n", .{});
    // Check if zarn.toml file was created
    const file = tmp_dir.dir.openFile("zarn.toml", .{}) catch |err| {
        std.debug.print("Error opening zarn.toml: {}\n", .{err});
        return err;
    };
    defer file.close();

    std.debug.print("Reading zarn.toml\n", .{});
    // Read and verify the contents of zarn.toml
    var buf: [1024]u8 = undefined;
    const bytes_read = try file.readAll(&buf);
    const content = buf[0..bytes_read];

    try std.testing.expect(std.mem.indexOf(u8, content, "name = \"test_project\"") != null);
    try std.testing.expect(std.mem.indexOf(u8, content, "version = \"1.0.0\"") != null);

    std.debug.print("Test completed\n", .{});
}
