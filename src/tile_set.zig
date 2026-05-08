const std = @import("std");

const tile = @import("tile.zig");
const Tile = tile.Tile;
const Color = tile.Color;
const Number = tile.Number;

const Round = @import("Round.zig");

pub const TileSet = union(enum) {
    group: Group,
    run: Run,

    const min_set_len = 3;

    pub fn init(tiles: []const Tile) !TileSet {
        return if (Group.init(tiles)) |group| .{ .group = group } else |_| if (Run.init(tiles)) |run| .{ .run = run } else |_| error.AllFailed;
    }

    const Group = struct {
        number: Number,
        colors: std.EnumSet(Color) = .empty,
        jokers: struct {
            colors: [Round.max_jokers]Color = undefined,
            len: usize = 0,

            pub fn add(self: *@This(), color: Color) !void {
                if (self.len >= self.colors.len) return error.TooManyJokers;
                self.colors[self.len] = color;
                self.len += 1;
            }

            pub fn slice(self: *@This()) []Color {
                return self.colors[0..self.len];
            }

            pub fn constSlice(self: *const @This()) []const Color {
                return self.colors[0..self.len];
            }
        } = .{},

        pub fn init(tiles: []const Tile) !Group {
            if (tiles.len < min_set_len) return error.TooTiny;
            if (tiles.len > Color.len) return error.TooBeeg;

            var ret = Group{
                .number = if (tiles[0].effectiveValue()) |t| t.number else return error.UnassignedJoker,
            };

            for (tiles) |t| {
                const tv = t.effectiveValue() orelse return error.UnassignedJoker;

                if (t == .joker) try ret.jokers.add(tv.color);

                if (ret.number != tv.number) return error.MismatchedNumber;
                if (ret.colors.contains(tv.color)) return error.DuplicateColor;
                ret.colors.insert(tv.color);
            }

            return ret;
        }
    };

    const Run = struct {
        start: Number,
        end: Number,
        color: Color,
        jokers: struct {
            numbers: [Round.max_jokers]Number = undefined,
            len: usize = 0,

            pub fn add(self: *@This(), number: Number) !void {
                if (self.len >= self.numbers.len) return error.TooManyJokers;
                self.numbers[self.len] = number;
                self.len += 1;
            }

            pub fn slice(self: *@This()) []Number {
                return self.numbers[0..self.len];
            }

            pub fn constSlice(self: *const @This()) []const Color {
                return self.colors[0..self.len];
            }
        } = .{},

        pub fn init(tiles: []const Tile) !Run {
            if (tiles.len < 3) return error.TooTiny;
            if (tiles.len > Number.len) return error.TooBeeg;

            var buf: [Number.len]Tile = undefined;
            var sorted = buf[0..tiles.len];
            @memcpy(sorted, tiles);

            try Tile.sortSlice(sorted);

            const first = sorted[0].effectiveValue().?;

            var ret = Run{
                .start = first.number,
                .end = sorted[sorted.len - 1].effectiveValue().?.number,
                .color = first.color,
            };

            for (sorted, 0..) |t, i| {
                const tv = t.effectiveValue().?;
                if (ret.color != tv.color) return error.MismatchedColor;
                if (@intFromEnum(tv.number) - i != @intFromEnum(ret.start)) return error.NonConsecutive;
                if (t == .joker) try ret.jokers.add(tv.number);
            }

            return ret;
        }
    };
};
