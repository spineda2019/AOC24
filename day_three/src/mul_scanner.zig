const std = @import("std");

const Product: type = struct {
    unfiltered_product: u128,
    filtered_product: u128,

    pub fn add(self: *Product, other: Product) void {
        self.unfiltered_product += other.unfiltered_product;
        self.filtered_product += other.filtered_product;
    }
};

/// Stupid state machine
fn getMulFromLime(line: []const u8) !Product {
    var last_char: ?u8 = null;
    var left_operand_string: [3:0]u8 = .{ 0, 0, 0 };
    var right_operand_string: [3:0]u8 = .{ 0, 0, 0 };

    var left_num: u128 = 1;
    var right_num: u128 = 1;

    var ready_for_left: bool = false;
    var ready_for_right: bool = false;

    var left_ptr: u8 = 0;
    var right_ptr: u8 = 0;

    var product: u128 = 0;
    var unconditional_product: u128 = 0;

    const StaticStorageStruct = struct {
        var do: bool = true;
        var look_for_do: bool = false;
        var look_for_dont: bool = false;
    };

    for (line) |character| {
        switch (character) {
            'd' => {
                last_char = 'd';
                ready_for_left = false;
                ready_for_right = false;
                @memset(&left_operand_string, 0);
                @memset(&right_operand_string, 0);
                left_ptr = 0;
                right_ptr = 0;
                StaticStorageStruct.look_for_do = true;
            },
            'o' => {
                if (last_char) |last| {
                    if (StaticStorageStruct.look_for_do) {
                        last_char = switch (last) {
                            'd' => 'o',
                            else => label: {
                                ready_for_left = false;
                                ready_for_right = false;
                                @memset(&left_operand_string, 0);
                                @memset(&right_operand_string, 0);
                                left_ptr = 0;
                                right_ptr = 0;
                                StaticStorageStruct.look_for_do = false;
                                StaticStorageStruct.look_for_dont = false;
                                break :label null;
                            },
                        };
                    } else {
                        ready_for_left = false;
                        ready_for_right = false;
                        @memset(&left_operand_string, 0);
                        @memset(&right_operand_string, 0);
                        left_ptr = 0;
                        right_ptr = 0;
                        StaticStorageStruct.look_for_do = false;
                        StaticStorageStruct.look_for_dont = false;
                        last_char = null;
                    }
                } else {
                    ready_for_left = false;
                    ready_for_right = false;
                    @memset(&left_operand_string, 0);
                    @memset(&right_operand_string, 0);
                    left_ptr = 0;
                    right_ptr = 0;
                    StaticStorageStruct.look_for_do = false;
                    StaticStorageStruct.look_for_dont = false;
                }
            },
            'n' => {
                if (last_char) |last| {
                    if (StaticStorageStruct.look_for_do) {
                        last_char = switch (last) {
                            'o' => blk: {
                                StaticStorageStruct.look_for_dont = true;
                                StaticStorageStruct.look_for_do = false;
                                break :blk 'n';
                            },
                            else => label: {
                                ready_for_left = false;
                                ready_for_right = false;
                                @memset(&left_operand_string, 0);
                                @memset(&right_operand_string, 0);
                                StaticStorageStruct.look_for_do = false;
                                StaticStorageStruct.look_for_dont = false;
                                left_ptr = 0;
                                right_ptr = 0;
                                break :label null;
                            },
                        };
                    } else {
                        ready_for_left = false;
                        ready_for_right = false;
                        @memset(&left_operand_string, 0);
                        @memset(&right_operand_string, 0);
                        left_ptr = 0;
                        right_ptr = 0;
                        StaticStorageStruct.look_for_do = false;
                        StaticStorageStruct.look_for_dont = false;
                        last_char = null;
                    }
                } else {
                    ready_for_left = false;
                    ready_for_right = false;
                    @memset(&left_operand_string, 0);
                    @memset(&right_operand_string, 0);
                    StaticStorageStruct.look_for_do = false;
                    StaticStorageStruct.look_for_dont = false;
                    left_ptr = 0;
                    right_ptr = 0;
                }
            },
            '\'' => {
                if (last_char) |last| {
                    if (StaticStorageStruct.look_for_dont and !StaticStorageStruct.look_for_do) {
                        last_char = switch (last) {
                            'n' => '\'',
                            else => label: {
                                ready_for_left = false;
                                ready_for_right = false;
                                @memset(&left_operand_string, 0);
                                @memset(&right_operand_string, 0);
                                StaticStorageStruct.look_for_do = false;
                                StaticStorageStruct.look_for_dont = false;
                                left_ptr = 0;
                                right_ptr = 0;
                                break :label null;
                            },
                        };
                    } else {
                        ready_for_left = false;
                        ready_for_right = false;
                        @memset(&left_operand_string, 0);
                        @memset(&right_operand_string, 0);
                        left_ptr = 0;
                        right_ptr = 0;
                        StaticStorageStruct.look_for_do = false;
                        StaticStorageStruct.look_for_dont = false;
                        last_char = null;
                    }
                } else {
                    ready_for_left = false;
                    ready_for_right = false;
                    @memset(&left_operand_string, 0);
                    @memset(&right_operand_string, 0);
                    StaticStorageStruct.look_for_do = false;
                    StaticStorageStruct.look_for_dont = false;
                    left_ptr = 0;
                    right_ptr = 0;
                }
            },
            't' => {
                if (last_char) |last| {
                    if (StaticStorageStruct.look_for_dont and !StaticStorageStruct.look_for_do) {
                        last_char = switch (last) {
                            '\'' => 't',
                            else => label: {
                                ready_for_left = false;
                                ready_for_right = false;
                                @memset(&left_operand_string, 0);
                                @memset(&right_operand_string, 0);
                                StaticStorageStruct.look_for_do = false;
                                StaticStorageStruct.look_for_dont = false;
                                left_ptr = 0;
                                right_ptr = 0;
                                break :label null;
                            },
                        };
                    } else {
                        ready_for_left = false;
                        ready_for_right = false;
                        @memset(&left_operand_string, 0);
                        @memset(&right_operand_string, 0);
                        left_ptr = 0;
                        right_ptr = 0;
                        StaticStorageStruct.look_for_do = false;
                        StaticStorageStruct.look_for_dont = false;
                        last_char = null;
                    }
                } else {
                    ready_for_left = false;
                    ready_for_right = false;
                    @memset(&left_operand_string, 0);
                    @memset(&right_operand_string, 0);
                    StaticStorageStruct.look_for_do = false;
                    StaticStorageStruct.look_for_dont = false;
                    left_ptr = 0;
                    right_ptr = 0;
                }
            },
            'm' => {
                last_char = 'm';
                ready_for_left = false;
                ready_for_right = false;
                @memset(&left_operand_string, 0);
                @memset(&right_operand_string, 0);
                StaticStorageStruct.look_for_do = false;
                StaticStorageStruct.look_for_dont = false;
                left_ptr = 0;
                right_ptr = 0;
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
                            StaticStorageStruct.look_for_do = false;
                            StaticStorageStruct.look_for_dont = false;
                            left_ptr = 0;
                            right_ptr = 0;
                            break :label null;
                        },
                    };
                } else {
                    ready_for_left = false;
                    ready_for_right = false;
                    @memset(&left_operand_string, 0);
                    @memset(&right_operand_string, 0);
                    StaticStorageStruct.look_for_do = false;
                    StaticStorageStruct.look_for_dont = false;
                    left_ptr = 0;
                    right_ptr = 0;
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
                            StaticStorageStruct.look_for_do = false;
                            StaticStorageStruct.look_for_dont = false;
                            left_ptr = 0;
                            right_ptr = 0;
                            break :label null;
                        },
                    };
                } else {
                    ready_for_left = false;
                    ready_for_right = false;
                    @memset(&left_operand_string, 0);
                    @memset(&right_operand_string, 0);
                    StaticStorageStruct.look_for_do = false;
                    StaticStorageStruct.look_for_dont = false;
                    left_ptr = 0;
                    right_ptr = 0;
                }
            },
            '(' => {
                if (last_char) |last| {
                    last_char = switch (last) {
                        'l' => '(',
                        't' => blk: {
                            if (StaticStorageStruct.look_for_dont and !StaticStorageStruct.look_for_do) {
                                break :blk '(';
                            } else {
                                ready_for_left = false;
                                ready_for_right = false;
                                @memset(&left_operand_string, 0);
                                @memset(&right_operand_string, 0);
                                StaticStorageStruct.look_for_do = false;
                                StaticStorageStruct.look_for_dont = false;
                                left_ptr = 0;
                                right_ptr = 0;
                                break :blk null;
                            }
                        },
                        'o' => blk: {
                            if (!StaticStorageStruct.look_for_dont and StaticStorageStruct.look_for_do) {
                                break :blk '(';
                            } else {
                                ready_for_left = false;
                                ready_for_right = false;
                                @memset(&left_operand_string, 0);
                                @memset(&right_operand_string, 0);
                                StaticStorageStruct.look_for_do = false;
                                StaticStorageStruct.look_for_dont = false;
                                left_ptr = 0;
                                right_ptr = 0;
                                break :blk null;
                            }
                        },
                        else => label: {
                            ready_for_left = false;
                            ready_for_right = false;
                            @memset(&left_operand_string, 0);
                            @memset(&right_operand_string, 0);
                            StaticStorageStruct.look_for_do = false;
                            StaticStorageStruct.look_for_dont = false;
                            left_ptr = 0;
                            right_ptr = 0;
                            break :label null;
                        },
                    };
                } else {
                    ready_for_left = false;
                    ready_for_right = false;
                    @memset(&left_operand_string, 0);
                    @memset(&right_operand_string, 0);
                    StaticStorageStruct.look_for_do = false;
                    StaticStorageStruct.look_for_dont = false;
                    left_ptr = 0;
                    right_ptr = 0;
                }
            },
            ',' => {
                if (last_char != null and ready_for_left and !ready_for_right) {
                    left_num = try std.fmt.parseInt(u128, left_operand_string[0..left_ptr], 10);
                    last_char = ',';
                } else {
                    ready_for_left = false;
                    ready_for_right = false;
                    @memset(&left_operand_string, 0);
                    @memset(&right_operand_string, 0);
                    StaticStorageStruct.look_for_do = false;
                    StaticStorageStruct.look_for_dont = false;
                    left_ptr = 0;
                    right_ptr = 0;
                    last_char = null;
                }
            },
            ')' => {
                if (StaticStorageStruct.look_for_do and StaticStorageStruct.look_for_dont) {
                    // only one must be set
                } else if (StaticStorageStruct.look_for_dont) {
                    StaticStorageStruct.do = false;
                } else if (StaticStorageStruct.look_for_do) {
                    StaticStorageStruct.do = true;
                } else if (last_char != null and ready_for_right and ready_for_left) {
                    right_num = try std.fmt.parseInt(u128, right_operand_string[0..right_ptr], 10);
                    unconditional_product += left_num * right_num;
                    if (StaticStorageStruct.do) {
                        product += left_num * right_num;
                    }
                    last_char = ')';
                }

                last_char = null;
                ready_for_left = false;
                ready_for_right = false;
                @memset(&left_operand_string, 0);
                @memset(&right_operand_string, 0);
                StaticStorageStruct.look_for_do = false;
                StaticStorageStruct.look_for_dont = false;
                left_ptr = 0;
                right_ptr = 0;
            },
            else => {
                // must be a digit with a nonnull last char
                if (last_char) |last| {
                    if (std.ascii.isDigit(character)) {
                        switch (last) {
                            '(' => {
                                ready_for_left = true;
                                left_operand_string[0] = character;
                                last_char = character;
                                left_ptr = 1;
                            },
                            ',' => {
                                ready_for_right = true;
                                right_operand_string[0] = character;
                                last_char = character;
                                right_ptr = 1;
                            },
                            else => {
                                if (std.ascii.isDigit(last)) {
                                    if (ready_for_right and ready_for_left) {
                                        right_operand_string[right_ptr] = character;
                                        right_ptr += 1;
                                    } else if (ready_for_left) {
                                        left_operand_string[left_ptr] = character;
                                        left_ptr += 1;
                                    } else {
                                        ready_for_left = false;
                                        ready_for_right = false;
                                        @memset(&left_operand_string, 0);
                                        @memset(&right_operand_string, 0);
                                        StaticStorageStruct.look_for_do = false;
                                        StaticStorageStruct.look_for_dont = false;
                                        left_ptr = 0;
                                        right_ptr = 0;
                                    }
                                } else {
                                    last_char = null;
                                    ready_for_left = false;
                                    ready_for_right = false;
                                    @memset(&left_operand_string, 0);
                                    @memset(&right_operand_string, 0);
                                    StaticStorageStruct.look_for_do = false;
                                    StaticStorageStruct.look_for_dont = false;
                                    left_ptr = 0;
                                    right_ptr = 0;
                                }
                            },
                        }
                    } else {
                        last_char = null;
                        ready_for_left = false;
                        ready_for_right = false;
                        @memset(&left_operand_string, 0);
                        @memset(&right_operand_string, 0);
                        StaticStorageStruct.look_for_do = false;
                        StaticStorageStruct.look_for_dont = false;
                        left_ptr = 0;
                        right_ptr = 0;
                    }
                } else {
                    last_char = null;
                    ready_for_left = false;
                    ready_for_right = false;
                    @memset(&left_operand_string, 0);
                    @memset(&right_operand_string, 0);
                    StaticStorageStruct.look_for_do = false;
                    StaticStorageStruct.look_for_dont = false;
                    left_ptr = 0;
                    right_ptr = 0;
                }
            },
        }
    }

    return Product{
        .unfiltered_product = unconditional_product,
        .filtered_product = product,
    };
}

pub fn scan(filename: []const u8) !void {
    var file = try std.fs.cwd().openFile(filename, .{});
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_reader = buf_reader.reader();

    var line_buffer: [4096]u8 = .{0} ** 4096;
    var product: Product = Product{
        .unfiltered_product = 0,
        .filtered_product = 0,
    };

    while (try in_reader.readUntilDelimiterOrEof(&line_buffer, '\n')) |line| {
        product.add(try getMulFromLime(line));
    }

    std.debug.print("Mul: {d}\n", .{product.filtered_product});
    std.debug.print("Unfiltered Mul: {d}\n", .{product.unfiltered_product});
}
