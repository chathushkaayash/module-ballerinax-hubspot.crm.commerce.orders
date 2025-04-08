import ballerina/io;

function userSpeakerService(string userName) {
    string messagePrefix = userName + " speaking : ";
    foreach int i in 0...9 {
       io:println(messagePrefix, i);
    }
}

public function main() {

    io:println("In function worker");

    // By default, named workers are multitasked cooperatively, not preemptively.
    // Each named worker has a strand (a logical thread of control) and
    // the execution switches between strands only at specific `yield` points.
    worker A {
        io:println("In worker A");
        userSpeakerService("Worker A");
        io:println("Worker A end");
    }

    worker B {
        io:println("In worker B");
        future<()> _ = start userSpeakerService("Worker B");
        io:println("Worker B end");
    }

    // Explicitly wait for named workers to complete.
    // This guarantees that the Ballerina program will not terminate till 
    // the workers have completed their execution.
    wait A;
    wait B;
}
