const std = @import("std");

const InputState: type = enum {
    Rule,
    Update,
};

const Rule: type = struct {
    before: u8,
    after: u8,

    pub fn isIn(self: *const Rule, others: []const Rule) bool {
        for (others) |other_rule| {
            if (self.before == other_rule.before and self.after == other_rule.after) {
                return true;
            }
        }
        return false;
    }
};

fn reorderBadUpdate(line: []const u8) u8 {
    _ = line;
    return 0;
}

fn checkUpdate(rules: []const Rule, line: []const u8) ?u8 {
    var left_ptr: u8 = 0;
    var right_ptr: u8 = 3;
    var seen: [256]u8 = .{0} ** 256;
    var seen_amount: u8 = 0;

    while (right_ptr < line.len - 1) : ({
        left_ptr = right_ptr;
        right_ptr += 3;
        seen_amount += 1;
    }) {
        const left: u8 = std.fmt.parseInt(u8, line[left_ptr .. left_ptr + 2], 10) catch {
            return null;
        };
        const right: u8 = std.fmt.parseInt(u8, line[right_ptr .. right_ptr + 2], 10) catch {
            return null;
        };

        seen[seen_amount] = left;

        for (seen[0 .. seen_amount + 1]) |previous_value| {
            // flip. If rules contain flipped rule, fail
            const pair: Rule = Rule{
                .before = right,
                .after = previous_value,
            };

            if (pair.isIn(rules)) {
                // out of order update
                return null;
            }
        }
    }

    return seen[seen_amount / 2];
}

/// Guaranteed to be of form: AB|CD
fn storeRule(rule: []const u8) !Rule {
    const left = rule[0..2];
    const right = rule[3..5];

    const left_num = try std.fmt.parseInt(u8, left, 10);
    const right_num = try std.fmt.parseInt(u8, right, 10);

    return .{
        .before = left_num,
        .after = right_num,
    };
}

pub fn solve_puzzle(filename: [:0]u8) !void {
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
    var reordered_num_sum: usize = 0;

    while (try in_reader.readUntilDelimiterOrEof(&line_buffer, '\n')) |line| {
        if (line.len == 0) {
            state = InputState.Update;
        } else {
            switch (state) {
                InputState.Update => {
                    if (checkUpdate(rule_buffer[0..rule_num], line)) |middle_number| {
                        middle_num_sum += middle_number;
                    } else {
                        reordered_num_sum += reorderBadUpdate(line);
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
    std.debug.print("Reordered Middle Number Sum: {d}\n", .{reordered_num_sum});
}
