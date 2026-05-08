const std = @import("std");
const Player = @import("player.zig").Player;
const Game = @import("Game.zig");

const Round = @This();

pub const max_jokers = 4;
pub const max_players = 6;
pub const max_tiles = 160;

players: struct {
    buf: [max_players]Player = undefined,
    len: usize = 0,
} = .{},
num_games: u8,
game_num: u8 = 0,

pub fn init(rng: std.Random, num_players: u3, num_games: u8) !Round {
    if (num_players < 2 or num_players > 6) return error.NumPlayers;

    _ = rng;
    var ret = Round{ .num_games = num_games };
    for (0..num_players) |i| {
        ret.players.buf[i] = .{ .random = .{ .base = .{ .rack = &.{} } } };
        ret.players.len += 1;
    }
    return ret;
}

pub fn play(self: *Round, rng: std.Random) void {
    while (self.game_num < self.num_games) {
        var game = Game.init(rng, self.players.buf[0..self.players.len]);
        game.play(rng);
        self.game_num += 1;
    }
}
