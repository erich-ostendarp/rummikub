const Move = @import("Move.zig");
const Game = @import("Game.zig");
const Tile = @import("tile.zig").Tile;

pub const Player = union(enum) {
    human: Human,
    random: Random,

    const Phase = union(enum) {
        initial_meld,
        play: *const Game,
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

        //TODO: stubbed out; implement
        pub fn getLegalMoves(self: Random) []Move {
            _ = self;
            return &.{};
        }
    };
};
