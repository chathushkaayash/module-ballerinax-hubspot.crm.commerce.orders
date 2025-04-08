import ballerina/http;
import ballerina/mqtt;
import ballerina/time;

type TemperatureDetails readonly & record {
    string deviceId;
    time:Utc timestamp;
    decimal temperature;
};

service / on new http:Listener(9090) {
    private final mqtt:Client temperaturePublisher;

    function init() returns error? {
        self.temperaturePublisher = check new ("tcp://localhost:1883", "temperature-pub-client", {
            connectionConfig: {
                username: "alice",
                password: "alice@123"
            }
        });
    }

    resource function post temperature(TemperatureDetails temperatureDetails) returns http:Accepted|error {
        _ = check self.temperaturePublisher->publish("mqtt/topic", {
            payload: temperatureDetails.toJsonString().toBytes()
        });
        return http:ACCEPTED;
    }
}
