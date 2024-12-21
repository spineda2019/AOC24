const std = @import("std");

const ProjectInfo = struct {
    name: []const u8,
    main_path: []const u8,
    run_name: []const u8,
    test_name: []const u8,
};

const projects: [12]ProjectInfo = .{
    ProjectInfo{
        .name = "day_one",
        .main_path = "day_one/src/main.zig",
        .run_name = "run_day_one",
        .test_name = "test_day_one",
    },
    ProjectInfo{
        .name = "day_two",
        .main_path = "day_two/src/main.zig",
        .run_name = "run_day_two",
        .test_name = "test_day_two",
    },
    ProjectInfo{
        .name = "day_three",
        .main_path = "day_three/src/main.zig",
        .run_name = "run_day_three",
        .test_name = "test_day_three",
    },
    ProjectInfo{
        .name = "day_four",
        .main_path = "day_four/src/main.zig",
        .run_name = "run_day_four",
        .test_name = "test_day_four",
    },
    ProjectInfo{
        .name = "day_five",
        .main_path = "day_five/src/main.zig",
        .run_name = "run_day_five",
        .test_name = "test_day_five",
    },
    ProjectInfo{
        .name = "day_six",
        .main_path = "day_six/src/main.zig",
        .run_name = "run_day_six",
        .test_name = "test_day_six",
    },
    ProjectInfo{
        .name = "day_seven",
        .main_path = "day_seven/src/main.zig",
        .run_name = "run_day_seven",
        .test_name = "test_day_seven",
    },
    ProjectInfo{
        .name = "day_eight",
        .main_path = "day_eight/src/main.zig",
        .run_name = "run_day_eight",
        .test_name = "test_day_eight",
    },
    ProjectInfo{
        .name = "day_nine",
        .main_path = "day_nine/src/main.zig",
        .run_name = "run_day_nine",
        .test_name = "test_day_nine",
    },
    ProjectInfo{
        .name = "day_ten",
        .main_path = "day_ten/src/main.zig",
        .run_name = "run_day_ten",
        .test_name = "test_day_ten",
    },
    ProjectInfo{
        .name = "day_eleven",
        .main_path = "day_eleven/src/main.zig",
        .run_name = "run_day_eleven",
        .test_name = "test_day_eleven",
    },
    ProjectInfo{
        .name = "day_twelve",
        .main_path = "day_twelve/src/main.zig",
        .run_name = "run_day_twelve",
        .test_name = "test_day_twelve",
    },
};

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    for (projects) |project| {
        const exe = b.addExecutable(.{
            .name = project.name,
            .root_source_file = b.path(project.main_path),
            .target = target,
            .optimize = optimize,
        });

        // This declares intent for the executable to be installed into the
        // standard location when the user invokes the "install" step (the default
        // step when running `zig build`).
        b.installArtifact(exe);

        // This *creates* a Run step in the build graph, to be executed when another
        // step is evaluated that depends on it. The next line below will establish
        // such a dependency.
        const run_cmd = b.addRunArtifact(exe);

        // By making the run step depend on the install step, it will be run from the
        // installation directory rather than directly from within the cache directory.
        // This is not necessary, however, if the application depends on other installed
        // files, this ensures they will be present and in the expected location.
        run_cmd.step.dependOn(b.getInstallStep());

        // This allows the user to pass arguments to the application in the build
        // command itself, like this: `zig build run -- arg1 arg2 etc`
        if (b.args) |args| {
            run_cmd.addArgs(args);
        }

        // This creates a build step. It will be visible in the `zig build --help` menu,
        // and can be selected like this: `zig build run`
        // This will evaluate the `run` step rather than the default, which is "install".
        const run_step = b.step(project.run_name, "Run the app");
        run_step.dependOn(&run_cmd.step);

        const exe_unit_tests = b.addTest(.{
            .root_source_file = b.path(project.main_path),
            .target = target,
            .optimize = optimize,
        });

        const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);

        // Similar to creating the run step earlier, this exposes a `test` step to
        // the `zig build --help` menu, providing a way for the user to request
        // running the unit tests.
        const test_step = b.step(project.test_name, "Run unit tests");
        test_step.dependOn(&run_exe_unit_tests.step);
    }
}
