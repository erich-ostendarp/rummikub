const std = @import("std");

pub fn factorial(n: comptime_int) u64 {
    var sum: u64 = 1;
    for (1..n + 1) |i| sum *= i;
    return sum;
}

// recursive binary splitting
// pub fn bs_factorial(n: comptime_int) u64 {
//     return bsf_helper(1, n + 1);
// }
//
// pub fn bsf_helper(a: comptime_int, b: comptime_int) u64 {
//     if (b - a == 1) return a;
//     if (b - a == 2) return a * (a + 1);
//
//     const half = (a + b) / 2;
//
//     return bsf_helper(a, half) * bsf_helper(half, b);
// }

test "factorial" {
    try std.testing.expect(factorial(1) == 1);
    try std.testing.expect(factorial(2) == 2);
    try std.testing.expect(factorial(3) == 6);
    try std.testing.expect(factorial(4) == 24);
}

pub fn choose(n: comptime_int, k: comptime_int) u64 {
    return factorial(n) / (factorial(k) * factorial(n - k));
}

test "choose" {
    try std.testing.expect(choose(1, 1) == 1);
    try std.testing.expect(choose(2, 1) == 2);
    try std.testing.expect(choose(2, 2) == 1);
    try std.testing.expect(choose(3, 2) == 3);
    try std.testing.expect(choose(4, 2) == 6);
    try std.testing.expect(choose(4, 3) == 4);
    std.debug.print("{}\n", .{choose(12, 3)});
}

pub fn permutations(n: comptime_int, k: comptime_int) u64 {
    return factorial(n) / factorial(n - k);
}

test "permutations" {
    try std.testing.expect(permutations(1, 1) == 1);
    try std.testing.expect(permutations(2, 1) == 2);
    try std.testing.expect(permutations(2, 2) == 2);
    try std.testing.expect(permutations(3, 2) == 6);
    try std.testing.expect(permutations(3, 3) == 6);
}

pub fn permutate(T: type, arr: []T, depth: u8, target: u8, current: []T, used: []bool) void {
    _ = arr;
    _ = depth;
    _ = target;
    _ = current;
    _ = used;
}

test "permute" {
    const T = @TypeOf(u8);
    const arr: []T = &.{};
    const target = 0;
    const current: []T = &.{};
    const used: []bool = &.{};

    permutate(u8, arr, 0, target, current, used);
}
