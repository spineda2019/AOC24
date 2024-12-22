const std = @import("std");

const ListPair: type = struct {
    left: []u32,
    right: []u32,

    pub fn sort(self: *const ListPair) void {
        std.mem.sort(u32, self.left, {}, comptime std.sort.desc(u32));
        std.mem.sort(u32, self.right, {}, comptime std.sort.desc(u32));
    }

    pub fn distance(self: *const ListPair) u128 {
        var dist: u128 = 0;
        for (self.left, self.right) |left, right| {
            if (left > right) {
                dist += @abs(left - right);
            } else {
                dist += @abs(right - left);
            }
        }
        return dist;
    }

    pub fn similarity(self: *const ListPair) u128 {
        var sim: u128 = 0;

        for (self.left) |left| {
            var freq: u16 = 0;
            for (self.right) |right| {
                if (left == right) {
                    freq += 1;
                }
            }

            sim += left * freq;
        }

        return sim;
    }
};

pub fn parse(filename: [:0]u8) !void {
    std.debug.print("Parsing file: {s}\n", .{filename});
    var file = try std.fs.cwd().openFile(filename, .{});
    var buf_reader = std.io.bufferedReader(file.reader());
    var in_reader = buf_reader.reader();

    var line_buffer: [16]u8 = .{0} ** 16;

    var left: [1000]u32 = .{0} ** 1000;
    var right: [1000]u32 = .{0} ** 1000;

    var counter: usize = 0;

    while (try in_reader.readUntilDelimiterOrEof(&line_buffer, '\n')) |line| {
        left[counter] = try std.fmt.parseInt(u32, line[0..5], 10);
        right[counter] = try std.fmt.parseInt(u32, line[8..13], 10);

        counter += 1;
    }

    var lists: ListPair = ListPair{
        .left = &left,
        .right = &right,
    };

    lists.sort();
    const distance: u128 = lists.distance();
    std.debug.print("Distance: {d}\n", .{distance});
    const sim: u128 = lists.similarity();
    std.debug.print("Similarity: {d}\n", .{sim});
}
