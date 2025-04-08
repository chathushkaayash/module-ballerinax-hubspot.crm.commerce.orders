import ballerina/io;

public function main() {
    // Creates a `map` constrained by the `int` type.
    map<int> ages = {
        "Tom": 23,
        "Jack": 34
    };

    // Gets the entry for `Tom`.
    int? v = ages["Tom"];
    io:println(v);

    // As there exists an entry for `Tom`, it can be accessed using the `map:get()` method. 
    // Using `ages["Tom"]` wouldn't work here because its type would be `int?` and  not `int`.
    int age = ages.get("Tom");
    io:println(age);

    // Adds a new entry for `Anne`.
    ages["Anne"] = 19;

    // The `map:hasKey()` method checks whether the map `age` has a member with `Jack` as the key.
    if ages.hasKey("Jack") {
        // The member with the key `Jack` can be removed using `map:remove()`.
        _ = ages.remove("Jack");
    }

    // `map:keys()` returns the keys as an array of strings.
    foreach string name in ages.keys() {
        io:println(name, " : ", ages[name]);
    }
}
