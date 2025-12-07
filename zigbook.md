# ZigBook

## 1. Core Philosophy
- No GC • No hidden allocations • No preprocessor • No macros
- Explicit over implicit
- Compile-time code execution (`comptime`) is the killer feature
- “If it compiles, it (probably) works”

## 2. Install & Update (2025 best way)
```bash
# One-liner for latest master (recommended)
curl -sSL https://git.io/zigup | bash -s --

# Or download from https://ziglang.org/download/
zig version   # → 0.14.0 or 0.15.0-dev.xxxx+abc123
```

## 3. Hello World
```zig
const std = @import("std");

pub fn main() void {
    std.debug.print("Hello Zig\n", .{});
}
```
Run: `zig run hello.zig`

## 4. Variables
```zig
const c = 42;     // immutable, type inferred
var v: i32 = 99;  // mutable, explicit type
comptime var x = 5; // known at compile time
```

## 5. Basic Types
| Type           | Description                     |
|----------------|---------------------------------|
| i8..i128       | Signed integers                 |
| u8..u128       | Unsigned                        |
| isize, usize   | Pointer-sized                   |
| f16,f32,f64,f128 | Floats                        |
| bool           | true / false                    |
| void           | {}                              |
| noreturn       | fn panic() noreturn             |
| ?T             | Optional (null or T)            |
| anyerror!T     | Error union                     |
| type           | Type of a type                  |

## 6. Strings & Slices
```zig
const s = "hello";           // *const [5:0]u8
var slice: []const u8 = s;   // slice
var bytes: []u8 = &buf;      // mutable slice
slice[0..2]                  // sub-slice
```

## 7. Optionals
```zig
var x: ?i32 = 42;
if (x) |val| { ... }        // unwrap if not null
const y = x orelse 0;       // default value
const z = x.?;              // panic if null
```

## 8. Error Handling (the Zig way)
```zig
const MyErr = error { NotFound, Overflow };

fn foo() MyErr!i32 {
    return error.NotFound;
}

const result = foo() catch |err| {
    std.log.err("{}", .{err});
    return;
};
try, catch, errdefer
```

## 9. Control Flow
```zig
// if as expression
const abs = if (x < 0) -x else x;

// switch – must be exhaustive
switch (value) {
    1     => std.debug.print("one", .{}),
    2,3   => |n| std.debug.print("{d}", .{n}),
    else  => {},
}
```

## 10. Loops
```zig
// while
while (i < 10) : (i += 1) { ... }

// for – only over arrays/slices
for (items, 0..) |item, i| { ... }

// loop with break label
outer: for (grid) |row| {
    for (row) |cell| {
        if (cell == target) break :outer;
    }
}
```

## 11. Functions
```zig
fn add(a: i32, b: i32) i32 { a + b }

pub fn main() !void { ... }     // can fail

// Generic (comptime)
fn Vec(comptime T: type, comptime n: usize) type {
    return [n]T;
}
const Vec3 = Vec(f32, 3);
```

## 12. Comptime – The Superpower
```zig
// Runs at compile time
comptime {
    const answer = 6 * 7;
    _ = answer; // 42
}

// Force comptime evaluation
const x = comptime fib(30);

// Generic magic
pub fn ArrayList(comptime T: type) type { ... }
```

## 13. Structs
```zig
const Point = struct {
    x: f32 = 0,
    y: f32 = 0,

    pub fn len(self: Point) f32 {
        return @sqrt(self.x*self.x + self.y*self.y);
    }
};

var p = Point{ .x = 3, .y = 4 };
_ = p.len(); // 5.0
```

## 14. Enums & Tagged Unions
```zig
const Token = enum { number, plus, minus, eof };

const Value = union(enum) {
    int: i64,
    float: f64,
    string: []const u8,
};

var v = Value{ .int = 42 };
switch (v) {
    .int => |n| std.debug.print("{d}", .{n}),
    else => {},
}
```

## 15. Pointers
| Syntax      | Meaning                          |
|-------------|----------------------------------|
| *T          | Single item pointer              |
| [*]T        | C-style many-item pointer        |
| []T         | Slice                            |
| ?*T         | Optional pointer                 |
| *const T    | Pointer to const data            |
| [*c]u8      | C string (null-terminated)       |

## 16. Allocators – The One Thing You Must Master
```zig
// 1. Arena (use 90% of the time)
var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
defer arena.deinit();
const alloc = arena.allocator();

// 2. GeneralPurposeAllocator (debugging)
var gpa = std.heap.GeneralPurposeAllocator(.{}){};
defer _ = gpa.deinit();
const alloc = gpa.allocator();

// Common ops
const mem = try alloc.alloc(u8, 100);
defer alloc.free(mem);

const str = try alloc.dupe(u8, "copy"); // owns new string
```

## 17. Defer vs Errdefer
```zig
defer file.close();        // always runs
errdefer file.close();     // only on error return
```

## 18. Standard Library Highlights
```zig
std.debug.print("{any}\n", .{value});
std.mem.eql(u8, a, b)
std.mem.copy(u8, dest, src)
std.fs.cwd().openFile(...)
std.json.Parser
std.ArrayList(T).init(alloc)
std.StringHashMap(T).init(alloc)
```

## 19. Build System (build.zig)
```zig
const std = @import("std");

pub fn build(b: *std.Build) void {
    const exe = b.addExecutable(.{
        .name = "myapp",
        .root_source_file = b.path("src/main.zig"),
        .target = b.standardTargetOptions(.{}),
        .optimize = b.standardOptimizeOption(.{}),
    });
    b.installArtifact(exe);
}
```
Run: `zig build run`

## 20. Advanced / Master Level
- async/await (fully manual, zero-cost)
- @cImport() for C headers
- Custom allocators in <50 LOC
- Compile-time reflection (@typeInfo, @field)
- SIMD vectors: `@Vector(4, f32)`
- Cache-friendly data structures
- Zero-cost abstractions everywhere
