const Player = @import("player.zig").Player;

const Game = @This();

players: []Player,
phase: Phase = .setup,

const Phase = union(enum) {
    setup,
    play: *Player,
};

pub fn init(players: []Player) !Game {
    _ = players;
    return error.Unimplemented;
}
