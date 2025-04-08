import ballerina/io;
import ballerina/persist;
import rainier.store;

store:Client sClient = check new ();

public function main() returns error? {
    // Get entire Employee record
    stream<store:Employee, persist:Error?> employees = sClient->/employees;
    check from var employee in employees
        do {
            io:println(employee);
        };
}
