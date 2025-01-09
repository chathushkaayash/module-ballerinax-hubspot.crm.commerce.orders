// Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
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

import ballerina/io;
import ballerina/oauth2;
import ballerinax/hubspot.crm.commerce.orders as orders;

// Configuration for HubSpot API client credentials
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

public function main() returns error? {
    // Initialize the HubSpot client with the given configuration
    orders:ConnectionConfig config = {
        auth: {
            clientId,
            clientSecret,
            refreshToken,
            credentialBearer: oauth2:POST_BODY_BEARER
        }
    };
    final orders:Client hubspotClient = check new orders:Client(config, serviceUrl = "https://api.hubapi.com/crm/v3/objects");
    io:println("HubSpot Client initialized successfully.");

    // Handle search operations
    check handleSearchOperations(hubspotClient);
}

// Function to handle all search operations
function handleSearchOperations(orders:Client hubspotClient) returns error? {
    io:println("Starting Search Operations...");

    // Perform order search
    check searchOrders(hubspotClient);

    io:println("Search Operations Completed.");
}

// Function to search for orders based on specific criteria
function searchOrders(orders:Client hubspotClient) returns error? {
    orders:PublicObjectSearchRequest searchRequest = {
        query: "example",
        properties: ["hs_order_name", "hs_currency_code"],
        filterGroups: [
            {
                filters: [
                    {
                        propertyName: "hs_order_name",
                        operator: "EQ",
                        value: "New Order Example"
                    }
                ]
            }
        ]
    };

    orders:CollectionResponseWithTotalSimplePublicObjectForwardPaging|error response = hubspotClient->/orders/search.post(searchRequest);
    if response is orders:CollectionResponseWithTotalSimplePublicObjectForwardPaging {
        io:println("Search results: ", response.results.length(), " orders found.");
    } else {
        io:println("No orders found matching search criteria.");
        return error("Search operation failed.");
    }
}
