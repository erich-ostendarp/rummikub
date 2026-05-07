const Player = @import("player.zig").Player;

const Round = @This();

pub const max_jokers = 4;

players: []Player,
num_games: u8,
game_num: u8 = 0,

pub fn init(num_players: u8, num_games: u8) !Round {
    _ = num_players;
    _ = num_games;
    return error.Unimplemented;
}

pub fn play(self: *Round) !void {
    _ = self;
}
