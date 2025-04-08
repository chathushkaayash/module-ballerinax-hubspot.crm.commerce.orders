// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import ballerina/http;
import ballerina/log;

# Represents a Service listener endpoint.
public class Listener {
    private http:Listener httpListener;
    private http:InferredListenerConfiguration listenerConfig;
    private int port;
    private HttpService? httpService;

    # Initiliazes the `websubhub:Listener` instance.
    # ```ballerina
    # listener websubhub:Listener hubListenerEp = check new (9090);
    # ```
    #
    # + listenTo - Port number or an `http:Listener` instance
    # + config - Custom `websubhub:ListenerConfiguration` to be provided to the underlying HTTP listener
    # + return - The `websubhub:Listener` or an `websubhub:Error` if the initialization failed
    public isolated function init(int|http:Listener listenTo, *ListenerConfiguration config) returns Error? {
        if listenTo is int {
            http:Listener|error httpListener = new(listenTo, config);
            if httpListener is http:Listener {
                self.httpListener = httpListener;
            } else {
                return error Error("Listener initialization failed", httpListener, statusCode = LISTENER_INIT_ERROR);
            }
        } else {
            self.httpListener = listenTo;
        }

        self.listenerConfig = self.httpListener.getConfig();
        self.port = self.httpListener.getPort();
        self.httpService = ();
    }

    # Attaches the provided `websubhub:Service` to the `websubhub:Listener`.
    # ```ballerina
    # check hubListenerEp.attach('service, "/hub");
    # ```
    # 
    # + 'service - The `websubhub:Service` object to attach
    # + name - The path of the service to be hosted
    # + return - An `websubhub:Error` if an error occurred during the service attaching process or else `()`
    public isolated function attach(Service 'service, string[]|string? name = ()) returns Error? {
        if self.listenerConfig.secureSocket is () {
            log:printWarn("HTTPS is recommended but using HTTP");
        }

        string hubUrl = self.retrieveHubUrl(name);
        ServiceConfiguration? configuration = retrieveServiceAnnotations('service);
        HttpToWebsubhubAdaptor adaptor = new ('service);
        self.httpService = new (adaptor, hubUrl, configuration);
        error? result = self.httpListener.attach(<HttpService>self.httpService, name);
        if (result is error) {
            return error Error("Error occurred while attaching the service", result, statusCode = LISTENER_ATTACH_ERROR);
        }
    }

    # Retrieves the URL on which the `hub` is published.
    # ```ballerina
    # string hubUrl = retrieveHubUrl("/hub");
    # ```
    #
    # + servicePath - Current service path
    # + return - Callback URL, which should be used in the subscription request
    isolated function retrieveHubUrl(string[]|string? servicePath) returns string {
        string host = self.listenerConfig.host;
        string protocol = self.listenerConfig.secureSocket is () ? "http" : "https";
        string concatenatedServicePath = "";        
        if servicePath is string {
            concatenatedServicePath += "/" + <string>servicePath;
        } else if servicePath is string[] {
            foreach var pathSegment in <string[]>servicePath {
                concatenatedServicePath += "/" + pathSegment;
            }
        }

        return protocol + "://" + host + ":" + self.port.toString() + concatenatedServicePath;
    }

    # Detaches the provided `websubhub:Service` from the `websubhub:Listener`.
    # ```ballerina
    # check hubListenerEp.detach('service);
    # ```
    # 
    # + s - The `websubhub:Service` object to be detached
    # + return - An `websubhub:Error` if an error occurred during the service detaching process or else `()`
    public isolated function detach(Service s) returns Error? {
        error? result = self.httpListener.detach(<HttpService> self.httpService);
        if (result is error) {
            return error Error("Error occurred while detaching the service", result, statusCode = LISTENER_DETACH_ERROR);
        }
    }

    # Starts the registered service programmatically.
    # ```ballerina
    # check hubListenerEp.'start();
    # ```
    # 
    # + return - An `websubhub:Error` if an error occurred during the listener-starting process or else `()`
    public isolated function 'start() returns Error? {
        error? listenerError = self.httpListener.'start();
        if (listenerError is error) {
            return error Error("Error occurred while starting the service", listenerError, statusCode = LISTENER_START_ERROR);
        }
    }

    # Gracefully stops the hub listener. Already-accepted requests will be served before the connection closure.
    # ```ballerina
    # check hubListenerEp.gracefulStop();
    # ```
    # 
    # + return - An `websubhub:Error` if an error occurred during the listener-stopping process
    public isolated function gracefulStop() returns Error? {
        error? result = self.httpListener.gracefulStop();
        if (result is error) {
            return error Error("Error occurred while stopping the service", result, statusCode = LISTENER_STOP_ERROR);
        }
    }

    # Stops the service listener immediately.
    # ```ballerina
    # check hubListenerEp.immediateStop();
    # ```
    # 
    # + return - An `websubhub:Error` if an error occurred during the listener-stopping process or else `()`
    public isolated function immediateStop() returns Error? {
        error? result = self.httpListener.immediateStop();
        if (result is error) {
            return error Error("Error occurred while stopping the service", result, statusCode = LISTENER_STOP_ERROR);
        }
    }
}

# Retrieves the `websubhub:ServiceConfiguration` annotation values.
# ```ballerina
# websubhub:ServiceConfiguration? config = retrieveServiceAnnotations('service);
# ```
# 
# + serviceType - Current `websubhub:Service` object
# + return - Provided `websubhub:ServiceConfiguration` or else `()`
isolated function retrieveServiceAnnotations(Service serviceType) returns ServiceConfiguration? {
    typedesc<any> serviceTypedesc = typeof serviceType;
    return serviceTypedesc.@ServiceConfig;
}
