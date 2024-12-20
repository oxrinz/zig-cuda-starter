const std = @import("std");

pub extern "c" fn addNumbers(a: i32, b: i32) i32;

export fn add(a: i32, b: i32) i32 {
    return addNumbers(a, b);
}
