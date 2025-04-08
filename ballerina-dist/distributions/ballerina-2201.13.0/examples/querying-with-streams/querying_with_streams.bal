import ballerina/io;

class EvenNumberGenerator {
    int i = 0;
    public isolated function next() returns record {|int value;|}|error? {
        self.i += 2;
        if self.i > 10 {
            return ();
        }

        return {value: self.i};
    }
}

public function main() returns error? {
    EvenNumberGenerator evenGen = new ();

    // Creates a `stream` passing an `EvenNumberGenerator` object to the `stream` constructor.
    stream<int, error?> evenNumberStream = new (evenGen);

    // Iterates the `evenNumberStream` until it returns `()`.
    // If the stream terminates with an error, the result of the query expression will be the error.
    int[] evenNumbers = check from var number in evenNumberStream
                        select number;

    io:println(evenNumbers);
}
