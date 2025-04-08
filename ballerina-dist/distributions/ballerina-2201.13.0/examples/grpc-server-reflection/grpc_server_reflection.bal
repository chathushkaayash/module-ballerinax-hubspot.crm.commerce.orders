import ballerina/grpc;

@grpc:Descriptor {
    value: GRPC_SIMPLE_DESC
}
service "HelloWorld" on new grpc:Listener(9090, {reflectionEnabled: true}) {

    remote function hello(string request) returns string {
        return "Hello " + request;
    }
}
