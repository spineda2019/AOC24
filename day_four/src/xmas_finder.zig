const std = @import("std");

const LetterSquare: type = struct {
    square: [][140]u8,

    pub fn init(square_view: [][140]u8) LetterSquare {
        return LetterSquare{ .square = square_view };
    }

    pub fn isXmas(self: *const LetterSquare) bool {
        for (self.square) |row| {
            for (row) |letter| {
                std.debug.print("{c}", .{letter});
            }
            std.debug.print("\n", .{});
        }
        std.debug.print("\n", .{});
        return false;
    }
};

/// Part 2
///     Summary:
///         Sliding window algorithm
fn countOtherXmas(view: [][140]u8) u32 {
    var xmas_count: u32 = 0;

    for (view, 0..) |line, rownum| {
        for (line, 0..) |_, colnum| {
            // row must be less than width-3 to prevent overlap
            // row must be less than height-3 to prevent overlap
            if (colnum < (line.len - 3) and rownum < (view.len - 3)) {
                const square: LetterSquare = LetterSquare.init(view[rownum .. rownum + 3][colnum .. colnum + 3]);
                if (square.isXmas()) {
                    xmas_count += 1;
                }
            }
        }
    }

    return xmas_count;
}

/// Part 1
fn countXmas(view: [][140]u8) u32 {
    var counter: u32 = 0;

    for (view, 0..) |line, row| {
        for (line, 0..) |letter, col| {
            if (letter == 'X') {
                const read_right: bool = col <= line.len - 4;
                const read_left: bool = col >= 3;
                const read_up: bool = row >= 3;
                const read_down: bool = row <= view.len - 4;
                const read_upright: bool = read_up and read_right;
                const read_downright: bool = read_down and read_right;
                const read_upleft: bool = read_up and read_left;
                const read_downleft: bool = read_down and read_left;

                if (read_right) {
                    if (line[col + 1] == 'M' and line[col + 2] == 'A' and line[col + 3] == 'S') {
                        counter += 1;
                    }
                }
                if (read_left) {
                    if (line[col - 1] == 'M' and line[col - 2] == 'A' and line[col - 3] == 'S') {
                        counter += 1;
                    }
                }
                if (read_up) {
                    if (view[row - 1][col] == 'M' and view[row - 2][col] == 'A' and view[row - 3][col] == 'S') {
                        counter += 1;
                    }
                }
                if (read_down) {
                    if (view[row + 1][col] == 'M' and view[row + 2][col] == 'A' and view[row + 3][col] == 'S') {
                        counter += 1;
                    }
                }
                if (read_upright) {
                    if (view[row - 1][col + 1] == 'M' and view[row - 2][col + 2] == 'A' and view[row - 3][col + 3] == 'S') {
                        counter += 1;
                    }
                }
                if (read_downright) {
                    if (view[row + 1][col + 1] == 'M' and view[row + 2][col + 2] == 'A' and view[row + 3][col + 3] == 'S') {
                        counter += 1;
                    }
                }
                if (read_upleft) {
                    if (view[row - 1][col - 1] == 'M' and view[row - 2][col - 2] == 'A' and view[row - 3][col - 3] == 'S') {
                        counter += 1;
                    }
                }
                if (read_downleft) {
                    if (view[row + 1][col - 1] == 'M' and view[row + 2][col - 2] == 'A' and view[row + 3][col - 3] == 'S') {
                        counter += 1;
                    }
                }
            }
        }
    }

    return counter;
}

pub fn find(filename: []const u8) !void {
    var file = try std.fs.cwd().openFile(filename, .{});
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_reader = buf_reader.reader();

    var line_buffer: [256]u8 = .{0} ** 256;

    // 19,600 bytes ~20kb of mem (is this bad?)
    var file_buffer: [140][140]u8 = .{.{0} ** 140} ** 140;

    var line_num: u8 = 0;

    while (try in_reader.readUntilDelimiterOrEof(&line_buffer, '\n')) |line| : (line_num += 1) {
        for (line, 0..) |character, col_num| {
            file_buffer[line_num][col_num] = character;
        }
    }

    const width: u8 = search: {
        for (file_buffer[0], 0..) |character, col| {
            if (character == 0) {
                break :search @intCast(col);
            }
        }
        break :search 140;
    };

    const xmas_count = countXmas(file_buffer[0..line_num][0..width]);
    const other_xmas_count = countOtherXmas(file_buffer[0..line_num][0..width]);

    std.debug.print("XMAS: {d}\n", .{xmas_count});
    std.debug.print("X-MAS: {d}\n", .{other_xmas_count});
}
