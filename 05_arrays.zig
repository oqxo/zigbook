const std = @import("std");

pub fn main() void {
    const array = [_]u8{ 'h', 'e', 'l', 'l', 'o' };
    const length = array.len; // 5
    std.debug.print("{d}" , .{length});
}