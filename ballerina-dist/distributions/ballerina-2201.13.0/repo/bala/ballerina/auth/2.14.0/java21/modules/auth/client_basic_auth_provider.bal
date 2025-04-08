// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

# Represents credentials for Basic Auth authentication.
#
# + username - Username for Basic Auth authentication
# + password - Password for Basic Auth authentication
public type CredentialsConfig record {|
    string username;
    string password;
|};

# Represents the client Basic Auth provider, which is used to authenticate with an external endpoint by generating a
# Basic Auth token against the provided credential configurations.
# ```ballerina
# auth:CredentialsConfig config = {
#     username: "tom",
#     password: "123"
# }
# auth:ClientBasicAuthProvider provider = new(config);
# ```
public isolated class ClientBasicAuthProvider {

    private final CredentialsConfig & readonly credentialsConfig;

    # Provides authentication based on the provided Basic Auth configurations.
    #
    # + credentialsConfig - Credentials configuration
    public isolated function init(CredentialsConfig credentialsConfig) {
        self.credentialsConfig = credentialsConfig.cloneReadOnly();
    }

    # Generates a Base64-encoded token for Basic Auth authentication.
    # ```ballerina
    # string token = check provider.generateToken();
    # ```
    #
    # + return - The generated token or else an `auth:Error` if an error occurred
    public isolated function generateToken() returns string|Error {
        if self.credentialsConfig.username == "" || self.credentialsConfig.password == "" {
            return prepareError("Username or password cannot be empty.");
        }
        string token = self.credentialsConfig.username + ":" + self.credentialsConfig.password;
        return token.toBytes().toBase64();
    }
}
