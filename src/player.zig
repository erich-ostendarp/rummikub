const std = @import("std");

const Move = @import("Move.zig");
const Round = @import("Round.zig");
const Tile = @import("tile.zig").Tile;
const TileSet = @import("tile_set.zig").TileSet;

pub const Player = union(enum) {
    human: Human,
    random: Random,

    const PhaseTag = enum {
        initial_meld,
        play,
    };

    pub const Phase = union(PhaseTag) {
        initial_meld: void,
        play: PlayState,
    };

    pub const PlayState = struct {
        tile_sets: []TileSet,
        opps: struct {
            buf: [Round.max_players]OppState = undefined,
            len: usize = 0,

            pub fn slice(self: *@This()) []OppState {
                return self.buf[0..self.len];
            }
        } = .{},

        pub const OppState = struct {
            tile_count: u8,
            score: u8,
            phase: PhaseTag,
        };
    };

    pub fn getBaseFields(self: Player) Base {
        return switch (self) {
            inline else => |p| p.base,
        };
    }

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

    const Base = struct {
        rack: []Tile,
        score: i16 = 0,
        phase: Phase = .initial_meld,
    };

    const Human = struct {
        base: Base,

        //TODO: stubbed out; implement
        pub fn getLegalMoves(self: Human) []Move {
            _ = self;
            return &.{};
        }
    };

    const Random = struct {
        base: Base,

        pub fn getLegalMoves(self: Random) []Move {
            switch (self.base.phase) {
                .initial_meld => {},
                .play => |play_state| {},
            }
            return &.{};
        }
    };
};
