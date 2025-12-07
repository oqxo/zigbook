const std = @import("std");

pub fn main() void {
    const number1:u8 = 255;
    std.debug.print("{d}\n", .{number1});

    const number2:u16 = 65535;
    std.debug.print("{d}\n", .{number2});

    const number3:u32 = 4_294_967_295;
    std.debug.print("{d}\n", .{number3});
}