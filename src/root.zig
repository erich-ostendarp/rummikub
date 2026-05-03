const std = @import("std");
const Io = std.Io;

const Move = struct {};

const Tile = union(enum) {
    standard: struct {
        color: Color,
        number: Number,
    },
    joker,

    const Color = enum {
        black,
        red,
        blue,
        yellow,
    };

    const Number = enum(u4) {
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
};

const Player = union(enum) {
    human: Human,
    random: Random,

    const Human = struct {
        tiles: []Tile,
    };

    const Random = struct {
        tiles: []Tile,
    };

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
};

const Phase = enum {};

const Game = struct {
    players: []Player,
    phase: Phase,
};

pub fn main(init: std.process.Init) !void {
    _ = init;
    std.debug.print("Hello, World!\n", .{});
}
