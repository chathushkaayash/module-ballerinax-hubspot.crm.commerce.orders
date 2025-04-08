import ballerina/io;

function matchCommand(any commands) {
    match commands {
        var [show] => {
            io:println(show);
        }
        // The list binding pattern below binds lists that contain three list items
        // where the third element in the list is the boolean value `true`.
        var [remove, all, isDir] if isDir is true => {
            io:println(remove, " directories ", all);
        }
        // The list binding pattern below binds lists that contain three list items.
        var [remove, all, _] => {
            io:println(remove, " files ", all);
        }
        // The list binding pattern below binds lists that contain two list items,
        // in which the second list item is also a list of two items.
        var [copy, [file1, file2]] => {
            io:println(copy, " ", file1, " into ", file2);
        }
        _ => {
            io:println("Unrecognized command.");
        }
    }
}


public function main() {
    matchCommand(["Show"]);
    matchCommand(["Remove", "*", true]);
    matchCommand(["Remove", "f.txt", false]);
    matchCommand(["Copy", ["a.bal", "b.bal"]]);
    matchCommand(1);
}
