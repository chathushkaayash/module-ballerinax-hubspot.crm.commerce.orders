import ballerina/http;
import ballerina/io;

type Album readonly & record {
    string title;
    string artist;
};

public function main() returns error? {
    // Define the load balance client endpoint to call the backend services.
    http:LoadBalanceClient albumClient = check new ({
        // Define the set of HTTP clients that need to be load balanced.
        targets: [
            {url: "http://localhost:9090"},
            {url: "http://localhost:9091"},
            {url: "http://localhost:9092"}
        ],
        timeout: 5
    });
    Album[] payload = check albumClient->/albums;
    io:println(payload);
}
