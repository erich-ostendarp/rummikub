const std = @import("std");
const Player = @import("player.zig").Player;
const Game = @import("Game.zig");

const Round = @This();

pub const max_jokers = 4;
pub const max_players = 6;

players: [max_players]Player = undefined,
players_len: u3,
num_games: u8,
game_num: u8 = 0,

pub fn init(num_players: u3, num_games: u8) Round {
    var ret = Round{ .players_len = num_players, .num_games = num_games };
    for (0..num_players) |i| ret.players[i] = .{ .random = .{ .base = .{ .rack = &.{} } } };
    return ret;
}

pub fn play(self: *Round) void {
    while (self.game_num < self.num_games) {
        var game = Game.init(self.players[0..self.players_len]);
        game.play();
        self.game_num += 1;
    }
}
