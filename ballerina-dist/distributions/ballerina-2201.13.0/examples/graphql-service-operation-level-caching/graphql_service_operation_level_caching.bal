import ballerina/graphql;

// Defines a `record` type to use as an object in the GraphQL service.
type User readonly & record {|
    int id;
    string name;
    int age;
|};

// Defines an in-memory table to store the users.
table<User> key(id) users = table [
    {id: 1, name: "Walter White", age: 50},
    {id: 2, name: "Jesse Pinkman", age: 25}
];

// The `cacheConfig` in the `graphql:ServiceConfig` annotation is used to 
// configure the cache for the GraphQL service.
// (default: {enabled: true, maxAge: 60, maxSize: 120})
@graphql:ServiceConfig {
    cacheConfig: {}
}
service /graphql on new graphql:Listener(9090) {

    resource function get name(int id) returns string|error {
        if users.hasKey(id) {
            return users.get(id).name;
        }
        return error(string `User with the ${id} not found`);
    }

    // The `enabled` field enables/disables the cache for the field. (default: true)
    @graphql:ResourceConfig {
        cacheConfig: {
            enabled: false
        }
    }
    resource function get user(int id) returns User|error {
        if users.hasKey(id) {
            return users.get(id);
        }
        return error(string `User with the ${id} not found`);
    }

    // The `maxAge` field sets the maximum age of the cache in seconds. (default: 60)
    // The `maxSize` field indicates the maximum capacity of the cache table by entries. 
    // (default: 120)
    @graphql:ResourceConfig {
        cacheConfig: {
            maxAge: 600,
            maxSize: 100
        }
    }
    resource function get age(int id) returns int|error {
        if users.hasKey(id) {
            return users.get(id).age;
        }
        return error(string `User with the ${id} not found`);
    }
}
