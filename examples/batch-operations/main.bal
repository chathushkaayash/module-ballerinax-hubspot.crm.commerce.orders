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
import ballerinax/hubspot.crm.commerce.orders as hsorders;

// Configuration for HubSpot API client credentials
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

public function main() returns error? {
    // Initialize the HubSpot client with the given configuration
    hsorders:ConnectionConfig config = {
        auth: {
            clientId,
            clientSecret,
            refreshToken,
            credentialBearer: oauth2:POST_BODY_BEARER
        }
    };
    final hsorders:Client hubspotClient = check new hsorders:Client(config);
    io:println("HubSpot Client initialized successfully.");

    // Handle batch operations
    handleBatchOperations(hubspotClient);
}

// Function to handle all batch operations
function handleBatchOperations(hsorders:Client hubspotClient) {
    io:println("Starting Batch Operations...");

    // Perform batch create orders
    batchCreateOrders(hubspotClient);

    // Perform batch update orders
    batchUpdateOrders(hubspotClient);
    io:println("Batch Operations Completed.");
}

// Function to create a batch of orders
function batchCreateOrders(hsorders:Client hubspotClient) {
    hsorders:BatchInputSimplePublicObjectInputForCreate batchCreateRequest = {
        inputs: [
            {
                associations: [
                    {
                        types: [
                            {
                                "associationCategory": "HUBSPOT_DEFINED",
                                "associationTypeId": 512
                            }
                        ],
                        to: {
                            id: "31440573867"
                        }
                    }
                ],
                properties: {
                    "hs_currency_code": "USD"
                }
            }
        ]
    };

    hsorders:BatchResponseSimplePublicObject|error response = 
        hubspotClient->/orders/batch/create.post(batchCreateRequest);
    if response is hsorders:BatchResponseSimplePublicObject {
        io:println("Batch of orders created successfully.");
    } else {
        io:println("Failed to create batch of orders.");
    }
}

// Function to update a batch of orders
function batchUpdateOrders(hsorders:Client hubspotClient) {
    hsorders:BatchInputSimplePublicObjectBatchInput batchUpdateRequest = {
        inputs: [
            {
                id: "394961395351",
                properties: {
                    "hs_fulfillment_status": "Delivered"
                }
            }
        ]
    };

    hsorders:BatchResponseSimplePublicObject|error response = 
        hubspotClient->/orders/batch/update.post(batchUpdateRequest);
    if response is hsorders:BatchResponseSimplePublicObject {
        io:println("Batch of orders updated successfully.");
    } else {
        io:println("Failed to update batch of orders.");
    }
}
