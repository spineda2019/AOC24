const std = @import("std");
const mls = @import("mul_scanner.zig");

const Error = error{
    BadArgCount,
};

pub fn main() !void {
    var alloc = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = alloc.allocator();
    defer _ = alloc.deinit();

    const iterator = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, iterator);

    if (iterator.len != 2) {
        std.debug.print("Invalid amount of arguments: {d}\n", .{iterator.len});
        return Error.BadArgCount;
    } else {
        const filepath: [:0]u8 = iterator[1];
        std.debug.print("Puzzle input given: {s}\n", .{filepath});
        try mls.scan(filepath);
    }
}
