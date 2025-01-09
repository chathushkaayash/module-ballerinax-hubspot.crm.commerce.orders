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
import ballerina/log;

listener http:Listener httpListener = new(9090);

http:Service mockService = service object {
    resource function post crm/v3/objects/orders/batch/create(@http:Payload BatchInputSimplePublicObjectInputForCreate payload) returns BatchResponseSimplePublicObject|error{
        return {
            "completedAt": "2025-01-08T16:43:05.686Z",
            "startedAt": "2025-01-08T16:43:05.384Z",
            "results": [
                {
                    "createdAt": "2025-01-08T16:43:05.440Z",
                    "archived": false,
                    "id": "395591235948",
                    "properties": {
                        "hs_currency_code": "USD",
                        "hs_exchange_rate": "1.0",
                        "hs_lastmodifieddate": "2025-01-08T16:43:05.440Z",
                        "hs_object_source_id": "6457564",
                        "hs_createdate": "2025-01-08T16:43:05.440Z",
                        "hs_object_id": "395591235948",
                        "hs_object_source": "INTEGRATION",
                        "hs_object_source_label": "INTEGRATION"
                    },
                    "updatedAt": "2025-01-08T16:43:05.440Z"
                }
            ],
            "status": "COMPLETE"
        };
    }

    resource function post crm/v3/objects/orders/batch/upsert(@http:Payload BatchInputSimplePublicObjectBatchInputUpsert payload) returns BatchResponseSimplePublicUpsertObject|error{
        return {
            "completedAt": "2025-01-08T16:43:06.213Z",
            "startedAt": "2025-01-08T16:43:06.140Z",
            "results": [
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
            ],
            "status": "COMPLETE"
        };
    }; 
};

function init() returns error?{
    log:printInfo("Initializing mock service");
    check httpListener.attach(mockService, "/");
    check httpListener.'start();
}
