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

import ballerina/http;
import ballerina/io;
import ballerina/log;
import ballerina/oauth2;
import ballerinax/hubspot.crm.commerce.orders as hsOrders;

// Configuration for HubSpot API client credentials
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

public function main() returns error? {
    // Initialize the HubSpot client with the given configuration
    hsOrders:ConnectionConfig config = {
        auth: {
            clientId,
            clientSecret,
            refreshToken,
            credentialBearer: oauth2:POST_BODY_BEARER
        }
    };
    final hsOrders:Client hubspotClient = check new hsOrders:Client(config);
    log:printInfo("HubSpot Client initialized successfully.");
    handleOrderManagement(hubspotClient);
}

function handleOrderManagement(hsOrders:Client hubspotClient) {
    io:println("Starting Order Management...");
    string|error newOrderId = "";
    newOrderId = createOrder(hubspotClient);
    if newOrderId is string {
        readOrder(hubspotClient, newOrderId);
        updateOrder(hubspotClient, newOrderId);
        deleteOrder(hubspotClient, newOrderId);
    } else {
        io:println("Failed to create order.");
        io:println("Order Management Exited With Error.");
    }
    io:println("Order Management Completed.");
}

// Create a new order
function createOrder(hsOrders:Client hubspotClient) returns string|error {
    hsOrders:SimplePublicObjectInputForCreate newOrder =
    {
        associations: [
            {
                to: {
                    id: "31440573867"
                },
                types: [
                    {
                        associationCategory: "HUBSPOT_DEFINED",
                        associationTypeId: 512
                    }
                ]
            }
        ],
        properties: {
            "hs_order_name": "Camping supplies",
            "hs_currency_code": "USD",
            "hs_source_store": "REI - Portland",
            "hs_fulfillment_status": "Packing",
            "hs_shipping_address_city": "Portland",
            "hs_shipping_address_state": "Maine",
            "hs_shipping_address_street": "123 Fake Street"
        }
    };
    hsOrders:SimplePublicObject|error response = hubspotClient->/orders.post(newOrder);
    if response is hsOrders:SimplePublicObject {
        io:println("Order created successfully with ID: ", response.id);
        return response.id;
    } else {
        io:println("Failed to create order.");
        return error("Failed to create order.");
    }
}

function readOrder(hsOrders:Client hubspotClient, string orderId) {
    var response = hubspotClient->/orders/[orderId];
    if response is hsOrders:SimplePublicObjectWithAssociations {
        io:println("Order details retrieved: ", response);
    } else {
        io:println("Failed to retrieve order with ID: ", orderId);
    }
}

function updateOrder(hsOrders:Client hubspotClient, string orderId) {
    hsOrders:SimplePublicObjectInput updateDetails = {
        properties: {
            "hs_fulfillment_status": "Shipped"
        }
    };
    var response = hubspotClient->/orders/[orderId].patch(updateDetails);
    if response is hsOrders:SimplePublicObject {
        log:printInfo("Order updated successfully with ID: "+ response.id);
    } else {
        log:printError("Failed to update order with ID: "+ orderId);
    }
}

function deleteOrder(hsOrders:Client hubspotClient, string orderId){
    http:Response|error response = hubspotClient->/orders/[orderId].delete();
    if response is http:Response {
        io:println("Order deleted successfully with status: ", response.statusCode);
    } else {
        log:printError("Failed to delete order with ID: " + orderId);
    }
}

