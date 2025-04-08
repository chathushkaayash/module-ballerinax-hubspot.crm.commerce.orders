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

import ballerina/http;
import ballerina/mime;

# The HTTP based client for WebSub subscription and unsubscription.
public isolated client class SubscriptionClient {
    private final string url;
    private final http:Client httpClient;

    # Initializes the `websub:SubscriptionClient` instance.
    # ```ballerina
    # websub:SubscriptionClient subscriptionClientEp = check new ("https://sample.hub.com");
    # ```
    # 
    # + url    - The URL at which the subscription should be changed
    # + config - Optional `ClientConfiguration` for the underlying client
    # + return - The `websub:SubscriptionClient` or an `websub:Error` if the initialization failed
    public isolated function init(string url, *ClientConfiguration config) returns Error? {
        self.url = url;
        http:ClientConfiguration clientConfig = retrieveHttpClientConfig(config);
        self.httpClient = check retrieveHttpClient(self.url, clientConfig);
    }

    # Sends a subscription request to the provided `hub`.
    # ```ballerina
    # websub:SubscriptionChangeResponse response = check subscriberClientEp->subscribe(subscriptionRequest);
    # ```
    #
    # + subscriptionRequest - The request payload containing the subscription details
    # + return - The `websub:SubscriptionChangeResponse` indicating that the subscription initiation was successful
    #            or else an `websub:SubscriptionInitiationError`
    isolated remote function subscribe(SubscriptionChangeRequest subscriptionRequest)
            returns SubscriptionChangeResponse|SubscriptionInitiationError {
        http:Client httpClient = self.httpClient;
        SubscriptionPayload payload = buildSubscriptionPayload(MODE_SUBSCRIBE, subscriptionRequest);
        http:Response|error response = httpClient->post("", payload, 
            headers = subscriptionRequest.customHeaders, mediaType = mime:APPLICATION_FORM_URLENCODED);
        return processHubResponse(self.url, MODE_SUBSCRIBE, subscriptionRequest.topic, response);
    }

    # Sends an unsubscription request to a WebSub Hub.
    # ```ballerina
    # websub:SubscriptionChangeResponse response = check subscriberClientEp->unsubscribe(subscriptionRequest);
    # ```
    # + unsubscriptionRequest - The request payload containing the unsubscription details
    # + return - The `websub:SubscriptionChangeResponse` indicating that the unsubscription initiation was successful
    #            or else an `websub:SubscriptionInitiationError`
    isolated remote function unsubscribe(SubscriptionChangeRequest unsubscriptionRequest)
            returns SubscriptionChangeResponse|SubscriptionInitiationError {
        http:Client httpClient = self.httpClient;
        SubscriptionPayload payload = buildSubscriptionPayload(MODE_UNSUBSCRIBE, unsubscriptionRequest);
        http:Response|error response = httpClient->post("", payload, 
            headers = unsubscriptionRequest.customHeaders, mediaType = mime:APPLICATION_FORM_URLENCODED);
        return processHubResponse(self.url, MODE_UNSUBSCRIBE, unsubscriptionRequest.topic, response);
    }

}

type SubscriptionPayload record {
    string hub\.mode;
    string hub\.topic;
    string hub\.callback;
    string hub\.secret?;
    string hub\.lease_seconds?;
};

isolated function buildSubscriptionPayload(string mode, SubscriptionChangeRequest subscriptionReq) returns SubscriptionPayload {
    SubscriptionPayload payload = {
        hub\.mode: mode,
        hub\.topic: subscriptionReq.topic,
        hub\.callback: subscriptionReq.callback
    };
    if mode == MODE_SUBSCRIBE {
        if subscriptionReq.secret.trim() != "" {
            payload.hub\.secret = subscriptionReq.secret;
        }
        if subscriptionReq.leaseSeconds != 0 {
            payload.hub\.lease_seconds = subscriptionReq.leaseSeconds.toString();
        }
    }
    map<string>? customParams = subscriptionReq.customParams;
    if customParams is map<string> {
        foreach var ['key, value] in customParams.entries() {
            payload['key] = value;
        }
    }
    return payload;
}

isolated function processHubResponse(string hub, string mode, string topic,
        http:Response|error response) returns SubscriptionChangeResponse|SubscriptionInitiationError {
    if response is error {
        return error SubscriptionInitiationError("Error occurred for request: Mode[" + mode + "] at Hub[" + hub + "] - " + response.message());
    }
    http:Response hubResponse = response;
    int responseStatusCode = hubResponse.statusCode;
    if responseStatusCode == http:STATUS_TEMPORARY_REDIRECT
                || responseStatusCode == http:STATUS_PERMANENT_REDIRECT {
        return error SubscriptionInitiationError("Redirection response received for subscription change request made with " +
                                "followRedirects disabled or after maxCount exceeded: Hub [" + hub + "], Topic [" + topic + "]");
    } else if !isSuccessStatusCode(responseStatusCode) {
        var responsePayload = hubResponse.getTextPayload();
        string errorMessage = "Error in request: Mode[" + mode + "] at Hub[" + hub + "]";
        if responsePayload is string {
            errorMessage = errorMessage + " - " + responsePayload;
        } else {
            errorMessage = errorMessage + " - Error occurred identifying cause: " + responsePayload.message();
        }
        return error SubscriptionInitiationError(errorMessage);
    } else {
        SubscriptionChangeResponse subscriptionChangeResponse = {hub: hub, topic: topic, response: hubResponse};
        return subscriptionChangeResponse;
    }
}
