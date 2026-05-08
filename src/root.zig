const std = @import("std");
const Io = std.Io;

const Round = @import("Round.zig");

pub fn main(init: std.process.Init) !void {
    _ = init;

    // const tiles = &[_]Tile{
    //     .{ .joker = .{ .color = .black, .number = .one } },
    //     .{ .standard = .{ .color = .black, .number = .two } },
    //     .{ .standard = .{ .color = .black, .number = .three } },
    // };
    //
    // const ts = try TileSet.init(tiles);
    var round = Round.init(2, 1);
    round.play();
}
