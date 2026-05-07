const std = @import("std");
const Io = std.Io;
const Tile = @import("tile.zig").Tile;
const TileSet = @import("tile_set.zig").TileSet;

pub fn main(init: std.process.Init) !void {
    _ = init;

    const tiles = &[_]Tile{
        .{ .joker = .{ .color = .black, .number = .one } },
        .{ .standard = .{ .color = .black, .number = .two } },
        .{ .standard = .{ .color = .black, .number = .three } },
    };

    const ts = try TileSet.init(tiles);

    std.debug.print("{any}\n", .{ts});
}
