pub const Move = union(enum) {
    draw,
    add_to_set,
    play_from_rack,
};
