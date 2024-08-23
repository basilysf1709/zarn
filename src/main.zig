const std = @import("std");
const cli = @import("cli/cli.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    try cli.run(allocator);
}

// Add tests
test "basic functionality" {
    // You can add some basic tests here
    try std.testing.expectEqual(true, true);
}

// Include tests from other modules
test {
    // This will run tests from all imported files
    std.testing.refAllDecls(@This());
}
