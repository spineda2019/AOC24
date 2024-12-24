const std = @import("std");

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

    std.debug.print("XMAS: {d}\n", .{xmas_count});
}
