const std = @import("std");

pub const Package = struct {
    name: []const u8,
    version: []const u8,
    dependencies: std.StringHashMap([]const u8),

    pub fn init(allocator: std.mem.Allocator, name: []const u8, version: []const u8) !Package {
        return Package{
            .name = try allocator.dupe(u8, name),
            .version = try allocator.dupe(u8, version),
            .dependencies = std.StringHashMap([]const u8).init(allocator),
        };
    }

    pub fn deinit(self: *Package) void {
        self.dependencies.deinit();
    }
};
