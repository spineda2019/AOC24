const std = @import("std");

pub fn find(filename: []const u8) !void {
    var file = try std.fs.cwd().openFile(filename, .{});
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_reader = buf_reader.reader();

    var line_buffer: [4096]u8 = .{0} ** 4096;

    var file_buffer: [140][140]u8 = .{.{0} ** 140} ** 140;

    _ = &file_buffer;

    while (try in_reader.readUntilDelimiterOrEof(&line_buffer, '\n')) |line| {
        _ = line;
    }
}
