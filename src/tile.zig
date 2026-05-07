const std = @import("std");

pub const Color = enum {
    pub const len = std.enums.values(Color).len;

    black,
    red,
    blue,
    yellow,
};

pub const Number = enum(u4) {
    pub const len = std.enums.values(Number).len;

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

pub const Tile = union(enum) {
    const Value = struct { color: Color, number: Number };

    standard: Value,
    joker: ?Value,

    pub fn effectiveValue(tile: Tile) ?Value {
        return switch (tile) {
            inline else => |t| t,
        };
    }

    const SortContext = struct {
        err: ?anyerror = null,

        fn lessThanFn(ctx: *SortContext, a: Tile, b: Tile) bool {
            if (ctx.err) |_| return false;

            const a_num = if (a.effectiveValue()) |a_tv| @intFromEnum(a_tv.number) else {
                ctx.err = error.UnassignedJoker;
                return false;
            };

            const b_num = if (b.effectiveValue()) |b_tv| @intFromEnum(b_tv.number) else {
                ctx.err = error.UnassignedJoker;
                return false;
            };
            return a_num < b_num;
        }
    };

    pub fn sortSlice(items: []Tile) !void {
        var ctx = SortContext{};
        std.mem.sort(Tile, items, &ctx, SortContext.lessThanFn);
        if (ctx.err) |e| return e;
    }
};
