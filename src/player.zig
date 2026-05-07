const Move = @import("Move.zig");
const Tile = @import("tile.zig").Tile;

const Player = union(enum) {
    human: Human,
    random: Random,

    const Phase = enum {
        initial_meld,
        play,
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

    const Base = struct {
        rack: []Tile,
        score: i16 = 0,
    };

    const Human = struct {
        base: Base,
    };

    const Random = struct {
        base: Base,
    };
};
