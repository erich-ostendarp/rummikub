const std = @import("std");
const Io = std.Io;

const rummikub = @import("rummikub");

pub fn main(init: std.process.Init) !void {
    try rummikub.main(init);
}
