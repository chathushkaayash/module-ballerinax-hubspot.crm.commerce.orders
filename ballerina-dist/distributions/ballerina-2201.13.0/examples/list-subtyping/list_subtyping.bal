import ballerina/io;

public function main() {
    int[3] numbers = [144, 232, 322];
    // `numbers`, of type `int[3]`, will be a subtype of `int[]`
    // since `T[n]` is a subtype of `T[]`
    io:println(numbers is int[]);

    byte[3] numbers2 = [1, 2, 3];
    // `numbers2`, of type byte[3], will be a subtype of `int[3]`
    // since `byte` is a subtype of `int` and lengths are the same
    io:println(numbers2 is int[3]);
    
    // `numbers2`, of type byte[3], will be a subtype of `int[]`
    // since `byte` is a subtype of `int` and `T[n]` is a subtype of `T[]`
    io:println(numbers2 is int[]);

    [byte, string] person = [1, "Mike"];
    // `[byte, string]` is a subtype of `[int, anydata]`
    io:println(person is [int, anydata]);
    
    // `[byte, string]` is a subtype of `[int, anydata...]`
    io:println(person is [int, anydata...]);
    
    // `int[3]` is a subtype of `[int, anydata...]`
    io:println(numbers is [int, anydata...]);
}
