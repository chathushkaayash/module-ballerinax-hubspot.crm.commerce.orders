import ballerina/io;

public function main() {
    boolean flag = true;
    io:println(flag);

    int x1 = 3;
    int x2 = 2;

    // The example below will output `false`.
    io:println(x1 < x2);
}
