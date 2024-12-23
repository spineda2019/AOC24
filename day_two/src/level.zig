const std = @import("std");

const ReportType: type = enum {
    Increasing,
    Decreasing,
};

/// Args:
///     line: slice of levels in NUMERIC form
inline fn isDampenedSafe(line: []const u8) bool {
    var tmp_buffer: [32]u8 = .{0} ** 32;
    for (line, 0..) |_, i| {
        @memset(&tmp_buffer, 0);
        var counter: u8 = 0;

        for (line, 0..) |value, j| {
            if (j == i) {
                continue;
            } else {
                tmp_buffer[counter] = value;
                counter += 1;
            }
        }

        const buffer: []const u8 = tmp_buffer[0..counter];

        if (isSafe(buffer)) {
            return true;
        }
    }
    return false;
}

/// Args:
///     line: slice of levels in NUMERIC form
inline fn isSafe(line: []const u8) bool {
    if (line[0] == line[1]) {
        return false;
    }

    // guaranteed at least 2 levels
    const report_type: ReportType = switch (line[1] > line[0]) {
        true => ReportType.Increasing,
        false => ReportType.Decreasing,
    };

    var last: u8 = line[0];
    const cut_line: []const u8 = line[1..];

    for (cut_line) |number| {
        if (number == last) {
            return false;
        }
        if (report_type == ReportType.Increasing and number < last) {
            return false;
        }
        if (report_type == ReportType.Decreasing and number > last) {
            return false;
        }
        if (number > last and @abs(number - last) > 3) {
            return false;
        } else if (last > number and @abs(last - number) > 3) {
            return false;
        }

        last = number;
    }
    return true;
}

pub fn parse(filename: []u8) !void {
    var file = try std.fs.cwd().openFile(filename, .{});
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_reader = buf_reader.reader();

    var line_buffer: [32]u8 = .{0} ** 32;
    var numeric_buffer: [32]u8 = .{0} ** 32;
    var counter: u8 = 0;

    var safe: u16 = 0;
    var dampened_safe: u16 = 0;
    var reports: u16 = 0;

    while (try in_reader.readUntilDelimiterOrEof(&line_buffer, '\n')) |line| : (reports += 1) {
        @memset(&numeric_buffer, 0); // clear
        counter = 0;

        var iterator = std.mem.split(u8, line, " ");
        while (iterator.next()) |number| : (counter += 1) {
            numeric_buffer[counter] = try std.fmt.parseInt(u8, number, 10);
        }

        if (isSafe(numeric_buffer[0..counter])) {
            safe += 1;
        } else if (isDampenedSafe(numeric_buffer[0..counter])) {
            dampened_safe += 1;
        }
    }

    std.debug.print("Safe: {d}\n", .{safe});
    std.debug.print("Dampened Safe: {d}\n", .{dampened_safe});
    std.debug.print("Total Safe: {d}\n", .{dampened_safe + safe});
    std.debug.print("Unsafe: {d}\n", .{reports - (dampened_safe + safe)});
}
