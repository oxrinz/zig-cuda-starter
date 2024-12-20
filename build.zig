const std = @import("std");
const gpu_arch = "sm_75";

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib = b.addSharedLibrary(.{
        .name = "starter",
        .root_source_file = .{ .cwd_relative = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const cuda_obj = compileCuda(b);
    lib.addObjectFile(.{ .cwd_relative = cuda_obj });

    const cuda_path = std.process.getEnvVarOwned(b.allocator, "CUDA_PATH") catch "/usr/local/cuda";
    defer b.allocator.free(cuda_path);

    lib.addIncludePath(.{ .cwd_relative = b.fmt("{s}/include", .{cuda_path}) });
    lib.addLibraryPath(.{ .cwd_relative = b.fmt("{s}/lib64", .{cuda_path}) });
    lib.linkSystemLibrary("cuda");
    lib.linkSystemLibrary("cudart");
    lib.linkLibC();

    const install = b.addInstallArtifact(lib, .{
        .dest_dir = .{ .override = .{ .custom = "." } },
    });
    b.getInstallStep().dependOn(&install.step);
}

fn compileCuda(b: *std.Build) []const u8 {
    const source_path = b.pathJoin(&.{ "src", "cuda", "add.cu" });
    const target_path = b.pathJoin(&.{ "src", "cuda", "cuda.o" });

    const nvcc_args = &.{
        "nvcc",
        "-c",
        source_path,
        "-o",
        target_path,
        "-O3",
        b.fmt("--gpu-architecture={s}", .{gpu_arch}),
        "--compiler-options",
        "-fPIC",
    };

    const result = std.process.Child.run(.{
        .allocator = b.allocator,
        .argv = nvcc_args,
    }) catch @panic("Failed to compile CUDA code");

    if (result.stderr.len != 0) {
        std.log.err("NVCC Error: {s}", .{result.stderr});
        @panic("Failed to compile CUDA code");
    }

    return target_path;
}
