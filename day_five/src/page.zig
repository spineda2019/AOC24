const std = @import("std");

const InputState: type = enum {
    Rule,
    Update,
};

const Rule: type = struct {
    before: u8,
    after: u8,
};

fn checkUpdate(rules: []const Rule, line: []const u8) ?u8 {
    var left_ptr: u8 = 0;
    var right_ptr: u8 = 3;

    while (right_ptr < line.len - 1) : ({
        left_ptr = right_ptr;
        right_ptr += 3;
    }) {
        std.debug.print("Pair: {s},{s}\n", .{
            line[left_ptr .. left_ptr + 2],
            line[right_ptr .. right_ptr + 2],
        });
    }

    _ = rules;
    return null;
}

/// Guaranteed to be of form: AB|CD
fn storeRule(rule: []const u8) !Rule {
    const left = rule[0..2];
    const right = rule[3..5];

    const left_num = try std.fmt.parseInt(u8, left, 10);
    const right_num = try std.fmt.parseInt(u8, right, 10);

    std.debug.print("Rule Pair: {d}|{d}\n", .{ left_num, right_num });
    return .{
        .before = left_num,
        .after = right_num,
    };
}

pub fn solve_puzzle(filename: [:0]u8) !void {
    std.debug.print("Parsing file: {s}\n", .{filename});
    var file = try std.fs.cwd().openFile(filename, .{});
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_reader = buf_reader.reader();

    var line_buffer: [128]u8 = .{0} ** 128;

    var state: InputState = InputState.Rule;

    var allocator = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer allocator.deinit();
    var map = std.AutoHashMap(u8, [256]u8).init(allocator.allocator());
    defer map.deinit();

    var rule_buffer: [2048]Rule = .{.{
        .before = 0,
        .after = 0,
    }} ** 2048;
    var rule_num: u16 = 0;
    var middle_num_sum: usize = 0;

    while (try in_reader.readUntilDelimiterOrEof(&line_buffer, '\n')) |line| {
        if (line.len == 0) {
            std.debug.print("Empty line detected!\n", .{});
            state = InputState.Update;
        } else {
            switch (state) {
                InputState.Update => {
                    if (checkUpdate(rule_buffer[0..rule_num], line)) |middle_number| {
                        middle_num_sum += middle_number;
                    }
                },
                InputState.Rule => {
                    rule_buffer[rule_num] = try storeRule(line);
                    rule_num += 1;
                },
            }
        }
    }

    std.debug.print("Middle Number Sum: {d}\n", .{middle_num_sum});
}
