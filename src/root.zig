const std = @import("std");
const Io = std.Io;

const Round = @import("Round.zig");

pub fn main(init: std.process.Init) !void {
    // const tiles = &[_]Tile{
    //     .{ .joker = .{ .color = .black, .number = .one } },
    //     .{ .standard = .{ .color = .black, .number = .two } },
    //     .{ .standard = .{ .color = .black, .number = .three } },
    // };
    //
    // const ts = try TileSet.init(tiles);
    const rng = (std.Random.IoSource{ .io = init.io }).interface();
    var round = try Round.init(rng, 2, 1);
    round.play(rng);
}
