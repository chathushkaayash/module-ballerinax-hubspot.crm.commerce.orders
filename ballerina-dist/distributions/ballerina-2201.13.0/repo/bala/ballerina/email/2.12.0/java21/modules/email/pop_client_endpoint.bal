// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/jballerina.java;

# Represents a POP Client, which interacts with a POP Server.
public isolated client class PopClient {

    # Gets invoked during the `email:PopClient` initialization.
    #
    # + host - Host of the POP Client
    # + username - Username of the POP Client
    # + password - Password of the POP Client
    # + clientConfig - Configurations for the POP Client
    # + return - An `email:Error` if creating the client failed or else `()`
    public isolated function init(string host, string username, string password,
            *PopConfiguration clientConfig) returns Error? {
        return initPopClientEndpoint(self, host, username, password, clientConfig);
    }

    # Reads a message.
    # ```ballerina
    # email:Message|email:Error? emailResponse = popClient->receiveMessage();
    # ```
    #
    # + folder - Folder to read the emails. The default value is `INBOX`
    # + timeout - Polling timeout period in seconds
    # + return - An `email:Message` if reading the message is successful,
    #            `()` if there are no emails in the specified folder,
    #            or else an `email:Error` if the recipient failed to receive the message
    remote isolated function receiveMessage(string folder = DEFAULT_FOLDER, decimal timeout = 30)
            returns Message|Error? {
        return popRead(self, folder, timeout);
    }

    # Close the client.
    # ```ballerina
    # email:Error? closeResponse = popClient->close();
    # ```
    #
    # + return - An `email:Error` if the recipient failed to close the client or else `()`
    remote isolated function close() returns Error? {
        return popClose(self);
    }

}

isolated function initPopClientEndpoint(PopClient clientEndpoint, string host, string username, string password,
        PopConfiguration config) returns Error? = @java:Method {
    name : "initPopClientEndpoint",
    'class : "io.ballerina.stdlib.email.client.EmailAccessClient"
} external;

isolated function popRead(PopClient clientEndpoint, string folder, decimal timeout)
        returns Message|Error? = @java:Method {
    name : "readMessage",
    'class : "io.ballerina.stdlib.email.client.EmailAccessClient"
} external;

isolated function popClose(PopClient clientEndpoint) returns Error? = @java:Method {
    name : "close",
    'class : "io.ballerina.stdlib.email.client.EmailAccessClient"
} external;

# Configuration of the POP Endpoint.
#
# + port - Port number of the POP server
# + security - Type of security channel
# + secureSocket - Secure socket configuration
public type PopConfiguration record {|
    int port = 995;
    Security security = SSL;
    SecureSocket secureSocket?;
|};
