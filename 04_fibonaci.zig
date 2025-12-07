const std = @import("std");

fn fibonacci(n: u32) u128 {
    var a: u128 = 0;
    var b: u128 = 1;
    var i: u32 = 0;

    while (i < n) : (i += 1) {
        const tmp = a + b;
        a = b;
        b = tmp;
    }

    return a;
}

pub fn main() void {
    const result = comptime fibonacci(100);
    std.debug.print("Fib(100) = {d}\n", .{result});
}
