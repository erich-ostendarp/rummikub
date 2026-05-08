const std = @import("std");
const Player = @import("player.zig").Player;

const Game = @This();

players: []Player,
phase: Phase = .setup,

const PlayerId = usize;

const Phase = union(enum) {
    setup,
    play: PlayerId,
};

pub fn init(players: []Player) Game {
    return .{ .players = players };
}

fn turn(self: *Game) void {
    self.phase = switch (self.phase) {
        .setup => .{ .play = 0 },
        .play => |p| .{ .play = (p + 1) % self.players.len },
    };
}

pub fn play(self: *Game) void {
    while (true) {
        var any_legal_moves = false;
        for (self.players) |player| {
            if (player.getBaseFields().rack.len == 0) return;
            if (player.getLegalMoves().len != 0) any_legal_moves = true;
        }
        if (!any_legal_moves) return;

        self.turn();
    }
}
