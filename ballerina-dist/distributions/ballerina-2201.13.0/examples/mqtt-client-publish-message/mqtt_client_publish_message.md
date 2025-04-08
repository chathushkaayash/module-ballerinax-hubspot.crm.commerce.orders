# MQTT client - Publish message

The `mqtt:Client` connects to a given MQTT server, and then, publishes messages to a specific topic in the server. An `mqtt:CLient` is created by giving the MQTT server URL and a unique ID. Once connected, the `publish` method is used to send messages to the MQTT server by providing the relevant topic and the message as the parameters. Use this to send messages to a topic in the MQTT server.

::: code mqtt_client_publish_message.bal :::

## Prerequisites
- Start an [MQTT broker](https://mqtt.org/software/) instance.
- Run the MQTT service given in the [MQTT service - Subscribe to messages](/learn/by-example/mqtt-service-subscribe-message) example.

Run the program by executing the following command.

::: out mqtt_client_publish_message.out :::

Invoke the service by executing the following cURL command in a new terminal.

::: out mqtt_client_publish_message.curl.out :::

## Related links
- [`mqtt:Client->publish` function - API documentation](https://lib.ballerina.io/ballerina/mqtt/latest#Client-publish)
- [`mqtt:Client` functions - Specification](/spec/mqtt/#33-functions)
