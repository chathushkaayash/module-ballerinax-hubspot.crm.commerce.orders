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

import ballerina/test;

final Client mockClient = check new Client(config, serviceUrl = "http://localhost:9090/crm/v3/objects");

@test:Config {}
isolated function mockTestForCreatingABatchOfOrders() returns error? {
    BatchResponseSimplePublicObject|error response = check mockClient->/orders/batch/create.post(
        {
            "inputs": [
                {
                    "associations": [
                        {
                            "types": [
                                {
                                    "associationCategory": "HUBSPOT_DEFINED",
                                    "associationTypeId": 512
                                }
                            ],
                            "to": {
                                "id": "31440573867"
                            }
                        }
                    ],
                    "properties": {
                        "hs_currency_code": "USD"
                    }
                }
            ]
        }
    );
    if (response is error) {
        test:assertFail("Error occurred while creating a batch of orders");
    } else {
        test:assertEquals(response.status, "COMPLETE");
    }
}

@test:Config {}
isolated function mockTestForCreatingBatchOfOrdersByUniqueProperty() returns error? {
    BatchResponseSimplePublicUpsertObject|BatchResponseSimplePublicUpsertObjectWithErrors response = check mockClient->/orders/batch/upsert.post(
        payload = {
            "inputs": [
                {
                    "idProperty": "my_unique_property_1",
                    "id": "unique_value",
                    "properties": {
                        "hs_billing_address_city": "mumbai",
                        "hs_billing_address_country": "india",
                        "hs_currency_code": "USD"
                    }
                }
            ]
        }
    );
    test:assertEquals(response.results[0],
            {
                "createdAt": "2025-01-07T06:02:00.230Z",
                "archived": false,
                "new": false,
                "id": "395261910382",
                "properties": {
                    "hs_currency_code": "USD",
                    "hs_lastmodifieddate": "2025-01-07T06:02:00.964Z",
                    "hs_object_source_id": "6457564",
                    "hs_createdate": "2025-01-07T06:02:00.230Z",
                    "hs_object_id": "395261910382",
                    "hs_billing_address_city": "mumbai",
                    "hs_object_source": "INTEGRATION",
                    "hs_billing_address_country": "india",
                    "hs_object_source_label": "INTEGRATION"
                },
                "updatedAt": "2025-01-07T06:02:00.964Z"
            }
    );
    test:assertEquals(response.status, "COMPLETE");
}

