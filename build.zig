const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "zarn",
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    // Create modules
    const cli_module = b.addModule("cli", .{
        .root_source_file = b.path("src/cli/cli.zig"),
    });

    const package_module = b.addModule("package", .{
        .root_source_file = b.path("src/package/package.zig"),
    });
    const build_module = b.addModule("build", .{
        .root_source_file = b.path("src/build/builder.zig"),
    });
    const resolver_module = b.addModule("resolver", .{
        .root_source_file = b.path("src/resolver/resolver.zig"),
    });
    const util_module = b.addModule("util", .{
        .root_source_file = b.path("src/util/util.zig"),
    });

    cli_module.addImport("package", package_module);

    // Add modules to the executable
    exe.root_module.addImport("cli", cli_module);
    exe.root_module.addImport("package", package_module);
    exe.root_module.addImport("build", build_module);
    exe.root_module.addImport("resolver", resolver_module);
    exe.root_module.addImport("util", util_module);

    const main_tests = b.addTest(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
    });

    const cli_tests = b.addTest(.{
        .root_source_file = b.path("tests/cli_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Add modules to test executables
    inline for ([_]struct { *std.Build.Step.Compile, []const u8 }{
        .{ main_tests, "main_tests" },
        .{ cli_tests, "cli_tests" },
    }) |t| {
        t[0].root_module.addImport("cli", cli_module);
        t[0].root_module.addImport("package", package_module);
        t[0].root_module.addImport("build", build_module);
        t[0].root_module.addImport("resolver", resolver_module);
        t[0].root_module.addImport("util", util_module);
    }

    const run_main_tests = b.addRunArtifact(main_tests);
    const run_cli_tests = b.addRunArtifact(cli_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_main_tests.step);
    test_step.dependOn(&run_cli_tests.step);
}
