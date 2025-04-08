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

# Represents the client JWT Auth provider, which is used to authenticate with an external endpoint by issuing a
# self-signed JWT against the provided JWT issuer configurations.
# ```ballerina
# jwt:ClientSelfSignedJwtAuthProvider provider = new({
#     issuer: "wso2",
#     audience: "ballerina",
#     keyStoreConfig: {
#         keyAlias: "ballerina",
#         keyPassword: "ballerina",
#         keyStore: {
#             path: "/path/to/keystore.p12",
#             password: "ballerina"
#         }
#     }
# });
# ```
public isolated class ClientSelfSignedJwtAuthProvider {

    private final IssuerConfig & readonly issuerConfig;

    # Provides authentication based on the provided JWT configurations.
    #
    # + issuerConfig - JWT issuer configurations
    public isolated function init(IssuerConfig issuerConfig) {
        self.issuerConfig = issuerConfig.cloneReadOnly();
    }

    # Issues a self-signed JWT for authentication.
    # ```ballerina
    # string token = check provider.generateToken();
    # ```
    #
    # + return - Generated token or else a `jwt:Error` if an error occurred
    public isolated function generateToken() returns string|Error {
        string|Error result = issue(self.issuerConfig);
        if result is string {
            return result;
        } else {
            return prepareError("Failed to generate a self-signed JWT.", result);
        }
    }
}
