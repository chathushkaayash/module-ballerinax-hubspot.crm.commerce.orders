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
import ballerina/oauth2;
import ballerina/test;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

OAuth2RefreshTokenGrantConfig auth = {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER
};

ConnectionConfig config = {auth: auth};
final Client baseClient = check new Client(config);

@test:Config {}
function testPostOrdersSearch() returns error? {
    PublicObjectSearchRequest payload = {
        query: "1",
        'limit: 0,
        after: "2",
        sorts: [
            "3"
        ],
        properties: ["hs_lastmodifieddate", "hs_createdate", "hs_object_id", "updatedAt"],
        filterGroups: [
            {
                filters: [
                    {
                        propertyName: "hs_source_store",
                        value: "REI - Portland",
                        operator: "EQ"
                    }
                ]
            }
        ]
    };
    CollectionResponseWithTotalSimplePublicObjectForwardPaging response = 
        check baseClient->/search.post(payload = payload);
    test:assertTrue(response.total >= 0);
}

@test:Config {}
function testPostOrdersBatchRead() returns error? {

    BatchReadInputSimplePublicObjectId payload = {
        propertiesWithHistory: [
            "hs_lastmodifieddate"
        ],
        inputs: [
            {
                id: "394961395351"
            }
        ],
        properties: ["hs_lastmodifieddate", "hs_createdate", "hs_object_id", "updatedAt"]
    };
    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors response = 
        check baseClient->/batch/read.post(payload = payload);
    if response.status != "PENDING" && response.status != "PROCESSING" 
        && response.status != "CANCELED" && response.status != "COMPLETE" {
        test:assertFail("invalid status type");
    }
    test:assertFalse(response.completedAt is "", "completedAt should not be empty");
    test:assertFalse(response.startedAt is "", "startedAt should not be empty");
}

@test:Config {}
function testDeleteObjectsOrdersByOrderId() returns error? {
    string orderId = "10";

    http:Response response = check baseClient->/[orderId].delete();
    test:assertTrue(response.statusCode == 204);
}

@test:Config {}
function testPatchObjectsOrdersByOrderId() returns error? {
    string orderId = "395972319872";
    SimplePublicObjectInput payload =
    {
        objectWriteTraceId: "10",
        properties: {
            "hs_lastmodifieddate": "2024-03-27T20:03:05.890Z",
            "hs_shipping_tracking_number": "123098521091"
        }
    };
    SimplePublicObject response = check baseClient->/[orderId].patch(payload = payload);
    test:assertFalse(response?.id is "", "id should not be empty");
    test:assertFalse(response?.createdAt is "", "creation time should not be empty");
    test:assertFalse(response?.updatedAt is "", "updated time should not be empty");
}

@test:Config {}
function testGetObjectsOrdersByOrderId() returns error? {
    string orderId = "395972319872";

    SimplePublicObjectWithAssociations response = check baseClient->/[orderId];
    test:assertFalse(response?.createdAt is "", "creation time should not be empty");
    test:assertFalse(response?.updatedAt is "", "updated time should not be empty");

}

@test:Config {}
function testPostordersBatchUpsert() returns error? {
    BatchInputSimplePublicObjectBatchInputUpsert payload = {
        inputs: [
            {
                idProperty: "my_unique_property_1",
                id: "unique_value",
                properties: {
                    "hs_billing_address_city": "mumbai",
                    "hs_billing_address_country": "india",
                    "hs_currency_code": "USD"

                }
            }
        ]
    };
    BatchResponseSimplePublicUpsertObject|BatchResponseSimplePublicUpsertObjectWithErrors response = 
        check baseClient->/batch/upsert.post(payload = payload);
    test:assertTrue(response.status == "COMPLETE");
    test:assertFalse(response?.completedAt is "", "creation time should not be empty");
    test:assertFalse(response?.startedAt is "", "start time should not be empty");
}

@test:Config {}
function testPostOrdersBatchCreate() returns error? {

    BatchInputSimplePublicObjectInputForCreate payload = {
        inputs: [
            {
                associations: [
                    {
                        types: [
                            {
                                associationCategory: "HUBSPOT_DEFINED",
                                associationTypeId: 512
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
    BatchResponseSimplePublicObject response = check baseClient->/batch/create.post(payload = payload);
    test:assertFalse(response.completedAt is "", "completedAt should not be empty");
    test:assertFalse(response.startedAt is "", "startedAt should not be empty");
}

@test:Config {}
function testPostObjectsOrdersBatchUpdate() returns error? {
    BatchInputSimplePublicObjectBatchInput payload =
    {
        inputs: [
            {
                id: "395267361897",
                properties: {
                    "hs_currency_code": "USD"
                }
            }
        ]
    };
    BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors response = 
        check baseClient->/batch/update.post(payload = payload);
    test:assertFalse(response.completedAt is "", "completedAt should not be empty");
    test:assertFalse(response.startedAt is "", "startedAt should not be empty");
}

@test:Config {}
function testPostObjectsOrders() returns error? {

    SimplePublicObjectInputForCreate payload =
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
        objectWriteTraceId: null,
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
    SimplePublicObject response = check baseClient->/.post(payload = payload);

    test:assertFalse(response.createdAt is "", "createdAt should not be empty");
    test:assertFalse(response.updatedAt is "", "updateAt should not be empty");

}

@test:Config {}
function testGetObjectsOrders() returns error? {
    CollectionResponseSimplePublicObjectWithAssociationsForwardPaging response = check baseClient->/;

    foreach SimplePublicObjectWithAssociations result in response.results {
        test:assertFalse(result.createdAt is "", "createdAt should not be empty");
        test:assertFalse(result.updatedAt is "", "updatedAt should not be empty");
    }
}

@test:Config {}
function testPostOrdersBatchArchive() returns error? {
    BatchInputSimplePublicObjectId payload = {
        inputs: [
            {
                id: "10"
            }
        ]
    };
    http:Response response = check baseClient->/batch/archive.post(payload = payload);
    test:assertTrue(response.statusCode == 204);
}
