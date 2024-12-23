const std = @import("std");

/// Stupid state machine
fn getMulFromLime(line: []const u8) !u16 {
    var last_char: ?u8 = null;
    var left_operand_string: [3:0]u8 = .{ 0, 0, 0 };
    var right_operand_string: [3:0]u8 = .{ 0, 0, 0 };

    var left_num: u16 = 1;
    var right_num: u16 = 1;

    var ready_for_left: bool = false;
    var ready_for_right: bool = false;

    var product: u16 = 1;

    for (line) |character| {
        switch (character) {
            'm' => {
                last_char = 'm';
            },
            'u' => {
                if (last_char) |last| {
                    last_char = switch (last) {
                        'm' => 'u',
                        else => label: {
                            ready_for_left = false;
                            ready_for_right = false;
                            @memset(&left_operand_string, 0);
                            @memset(&right_operand_string, 0);
                            break :label null;
                        },
                    };
                } else {
                    ready_for_left = false;
                    ready_for_right = false;
                    @memset(&left_operand_string, 0);
                    @memset(&right_operand_string, 0);
                }
            },
            'l' => {
                if (last_char) |last| {
                    last_char = switch (last) {
                        'u' => 'l',
                        else => label: {
                            ready_for_left = false;
                            ready_for_right = false;
                            @memset(&left_operand_string, 0);
                            @memset(&right_operand_string, 0);
                            break :label null;
                        },
                    };
                } else {
                    ready_for_left = false;
                    ready_for_right = false;
                    @memset(&left_operand_string, 0);
                    @memset(&right_operand_string, 0);
                }
            },
            '(' => {
                if (last_char) |last| {
                    last_char = switch (last) {
                        'l' => '(',
                        else => label: {
                            ready_for_left = false;
                            ready_for_right = false;
                            @memset(&left_operand_string, 0);
                            @memset(&right_operand_string, 0);
                            break :label null;
                        },
                    };
                } else {
                    ready_for_left = false;
                    ready_for_right = false;
                    @memset(&left_operand_string, 0);
                    @memset(&right_operand_string, 0);
                }
            },
            ',' => {
                if (last_char and ready_for_left) {
                    left_num = try std.fmt.parseInt(u8, &left_operand_string, 10);
                    last_char = ',';
                } else {
                    ready_for_left = false;
                    ready_for_right = false;
                    @memset(&left_operand_string, 0);
                    @memset(&right_operand_string, 0);
                }
            },
            ')' => {
                if (last_char and ready_for_right) {
                    right_num = try std.fmt.parseInt(u8, &right_operand_string, 10);
                    product += left_num * right_num;
                }

                ready_for_left = false;
                ready_for_right = false;
                @memset(&left_operand_string, 0);
                @memset(&right_operand_string, 0);
            },
            else => {
                // must be a digit with a nonnull last char
                if (std.ascii.isDigit(character)) {
                    if (last_char) |last| {
                        last_char = switch (last) {
                            '(' => label: {
                                ready_for_left = true;
                                left_operand_string[0] = character;
                                break :label character;
                            },
                            ',' => label: {
                                ready_for_right = true;
                                right_operand_string[0] = character;
                                break :label character;
                            },
                        };
                    }
                }
            },
        }
    }

    return product;
}

pub fn scan(filename: []const u8) !void {
    var file = try std.fs.cwd().openFile(filename, .{});
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_reader = buf_reader.reader();

    var line_buffer: [4096]u8 = .{0} ** 4096;
    var product: usize = 1;

    while (try in_reader.readUntilDelimiterOrEof(&line_buffer, '\n')) |line| {
        product *= try getMulFromLime(line);
    }

    std.debug.print("Mul: {d}\n", .{product});
}
