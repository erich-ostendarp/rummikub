const std = @import("std");
const Round = @import("Round.zig");
const Player = @import("player.zig").Player;
const TileSet = @import("tile_set.zig").TileSet;

const Game = @This();

players: []Player,
phase: Phase = .setup,
tile_sets: struct {
    buf: [Round.max_tiles / 3]TileSet = undefined,
    len: usize = 0,
} = .{},

const PlayerIdx = struct { idx: usize };

const Phase = union(enum) {
    setup: void,
    play: PlayerIdx,
};

pub fn getPlayState(self: Game, idx: PlayerIdx) Player.PlayState {
    var ret = Player.PlayState{ .tile_sets = self.tile_sets.items };
    for (self.players, 0..) |player, i| {
        if (i == idx) continue;

        const bf = player.getBaseFields();
        ret.opps.buf[ret.opps.len] = .{
            .tile_count = bf.rack.len,
            .score = bf.score,
            .phase = bf.phase,
        };
        ret.opps.len += 1;
    }
    return ret;
}

pub fn init(rng: std.Random, players: []Player) Game {
    _ = rng;
    return .{ .players = players };
}

fn turn(self: *Game, rng: std.Random) void {
    self.phase = switch (self.phase) {
        // TODO: implement ui so each player can draw and replace tile, highest going first
        .setup => .{ .play = .{ .idx = rng.uintLessThan(usize, self.players.len) } },
        .play => |p| .{ .play = .{ .idx = (p.idx + 1) % self.players.len } },
    };
}

pub fn play(self: *Game, rng: std.Random) void {
    while (true) {
        var any_legal_moves = false;
        for (self.players) |player| {
            if (player.getBaseFields().rack.len == 0) return;
            if (player.getLegalMoves().len != 0) any_legal_moves = true;
        }
        if (!any_legal_moves) return;

        self.turn(rng);
    }
}
