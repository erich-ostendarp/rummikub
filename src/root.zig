const std = @import("std");
const Io = std.Io;

const Move = struct {};

const Color = enum {
    const len = std.enums.values(Color).len;

    black,
    red,
    blue,
    yellow,
};

const Number = enum(u4) {
    const len = std.enums.values(Number).len;

    one = 1,
    two,
    three,
    four,
    five,
    six,
    seven,
    eight,
    nine,
    ten,
    eleven,
    twelve,
    thirteen,
};

const TileValue = struct { color: Color, number: Number };

const Tile = union(enum) {
    standard: TileValue,
    joker: ?TileValue,

    pub fn effectiveValue(tile: Tile) ?TileValue {
        return switch (tile) {
            inline else => |t| t,
        };
    }
};

const TileSet = union(enum) {
    const min_set_len = 3;

    group: Group,
    run: Run,

    const Group = struct {
        number: Number = undefined,
        colors: std.EnumSet(Color) = .empty,
        jokers: union(enum) {
            none,
            one: Color,
            two: struct { Color, Color },
        } = .none,

        pub fn init(tiles: []const Tile) !Group {
            if (tiles.len < min_set_len) return error.TooTiny;
            if (tiles.len > Color.len) return error.TooBeeg;

            var ret = Group{};

            ret.number = if (tiles[0].effectiveValue()) |t| t.number else return error.UnassignedJorker;

            for (tiles) |tile| {
                const tv = tile.effectiveValue() orelse error.UnassignedJorker;

                if (tile == .joker) {
                    ret.jokers = switch (ret.jokers) {
                        .none => .{ .one = tv.color },
                        .one => |o| .{ .two = .{ o, tv.color } },
                        .two => return error.TooManyJorkers,
                    };
                }

                if (ret.number != tv.number) return error.MismatchedNumber;
                ret.number = tv.number;

                if (ret.colors.contains(tv.color)) return error.DuplicateColor;
                ret.colors.insert(tv.color);
            }

            return ret;
        }
    };

    const Run = struct {
        start: Number = undefined,
        end: Number = undefined,
        color: Color = undefined,
        jokers: union(enum) {
            none,
            one: Number,
            two: struct { Number, Number },
        } = .none,

        pub fn init(tiles: []const Tile) !Run {
            if (tiles.len < 3) return error.TooTiny;
            if (tiles.len > Number.len) return error.TooBeeg;

            var buf: [Number.len]Tile = undefined;
            var sorted = std.ArrayList(Tile).initBuffer(&buf);
            sorted.appendSliceAssumeCapacity(tiles);

            var err: ?anyerror = null;
            std.mem.sort(Tile, sorted.items, &err, struct {
                fn lessThanFn(ctx: *?anyerror, a: Tile, b: Tile) bool {
                    const a_num = if (a.effectiveValue()) |a_tv| @intFromEnum(a_tv.number) else {
                        ctx.* = error.UnassignedJorker;
                        return false;
                    };

                    const b_num = if (b.effectiveValue()) |b_tv| @intFromEnum(b_tv.number) else {
                        ctx.* = error.UnassignedJorker;
                        return false;
                    };
                    return a_num < b_num;
                }
            }.lessThanFn);
            if (err) |e| return e;

            const first = sorted.items[0].effectiveValue().?;

            var ret = Run{
                .start = first.number,
                .end = sorted.items[sorted.items.len - 1].effectiveValue().?.number,
                .color = first.color,
            };

            for (sorted.items, 0..) |tile, i| {
                const tv = tile.effectiveValue().?;
                if (@intFromEnum(tv.number) - i != @intFromEnum(ret.start)) return error.NonConsecutive;

                if (tile == .joker) {
                    ret.jokers = switch (ret.jokers) {
                        .none => .{ .one = tv.number },
                        .one => |o| .{ .two = .{ o, tv.number } },
                        .two => return error.TooManyJorkers,
                    };
                }
            }

            return ret;
        }
    };
};

const Player = union(enum) {
    human: Human,
    random: Random,

    pub fn getLegalMoves(self: Player) []Move {
        return switch (self) {
            inline else => |p| p.getLegalMoves(),
        };
    }

    pub fn makeMove(self: Player) Move {
        return switch (self) {
            inline else => |p| p.makeMove(),
        };
    }

    const Human = struct {
        rack: []Tile,
    };

    const Random = struct {
        rack: []Tile,
    };
};

const Phase = enum {};

const Game = struct {
    players: []Player,
    phase: Phase,
};

pub fn main(init: std.process.Init) !void {
    _ = init;

    const tiles = &[_]Tile{
        .{ .joker = .{ .color = .black, .number = .one } },
        .{ .standard = .{ .color = .black, .number = .two } },
        .{ .standard = .{ .color = .black, .number = .three } },
    };
    const group = TileSet{ .run = try .init(tiles) };

    std.debug.print("{any}\n", .{group});
}
