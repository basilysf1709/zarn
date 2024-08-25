const std = @import("std");

pub const Package = struct {
    allocator: std.mem.Allocator,
    name: []const u8,
    version: []const u8,
    dependencies: std.StringHashMap([]const u8),

    pub fn init(allocator: std.mem.Allocator, name: []const u8, version: []const u8) !*Package {
        const self = try allocator.create(Package);
        self.* = .{
            .allocator = allocator,
            .name = try allocator.dupe(u8, name),
            .version = try allocator.dupe(u8, version),
            .dependencies = std.StringHashMap([]const u8).init(allocator),
        };
        return self;
    }

    pub fn deinit(self: *Package) void {
        self.allocator.free(self.name);
        self.allocator.free(self.version);
        self.dependencies.deinit();
        self.allocator.destroy(self);
    }
};
