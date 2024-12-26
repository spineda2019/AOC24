const std = @import("std");

const InputState: type = enum {
    Rule,
    Update,
};

fn checkUpdate() void {}

/// Guaranteed to be of form: AB|CD
fn storeRule(rule: []const u8) !void {
    const left = rule[0..2];
    const right = rule[3..5];

    const left_num = try std.fmt.parseInt(u8, left, 10);
    const right_num = try std.fmt.parseInt(u8, right, 10);

    std.debug.print("Rule Pair: {d}|{d}\n", .{ left_num, right_num });
}

pub fn solve_puzzle(filename: [:0]u8) !void {
    std.debug.print("Parsing file: {s}\n", .{filename});
    var file = try std.fs.cwd().openFile(filename, .{});
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_reader = buf_reader.reader();

    var line_buffer: [128]u8 = .{0} ** 128;

    var state: InputState = InputState.Rule;

    while (try in_reader.readUntilDelimiterOrEof(&line_buffer, '\n')) |line| {
        if (line.len == 0) {
            std.debug.print("Empty line detected!\n", .{});
            state = InputState.Update;
        } else {
            switch (state) {
                InputState.Update => checkUpdate(),
                InputState.Rule => try storeRule(&line_buffer),
            }
        }
    }
}
