import ballerina/test;
import ballerina/oauth2;
import ballerina/http;
import ballerina/io;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

OAuth2RefreshTokenGrantConfig auth = {
       clientId: clientId,
       clientSecret: clientSecret,
       refreshToken: refreshToken,
       credentialBearer: oauth2:POST_BODY_BEARER
};

ConnectionConfig config = {auth:auth};
final Client baseClient = check new Client(config, serviceUrl = "https://api.hubapi.com/crm/v3/objects");

@test:Config {}
 function  testPostOrdersSearch() returns error? {
  PublicObjectSearchRequest payload = {
    query: "1",
    'limit: 0,
    after: "2",
    sorts: [
      "3"
    ],
    properties: ["hs_lastmodifieddate", "hs_createdate", "hs_object_id","updatedAt"],
    "filterGroups": [
      {
        "filters": [
          {
            "propertyName": "hs_source_store",
            "value": "REI - Portland",
            "operator": "EQ"
          }
        ]
      }
    ]
  };
  CollectionResponseWithTotalSimplePublicObjectForwardPaging response = check baseClient->/orders/search.post(payload = payload);
    test:assertTrue(response.total >= 0);
    
}

@test:Config {}
function  testPostOrdersBatchRead() returns error?{

  BatchReadInputSimplePublicObjectId payload = {
  "propertiesWithHistory": [
    "string"
  ],
  "inputs": [
    {
      "id": "394961395351"
    }
  ],
  "properties": ["hs_lastmodifieddate", "hs_createdate", "hs_object_id","updatedAt"]
};
  BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors response = check baseClient->/orders/batch/read.post(payload = payload);

  if response.status != "PENDING" && response.status != "PROCESSING" && response.status != "CANCELED" && response.status != "COMPLETE" {
    test:assertFail("invalid status type");
  }
  test:assertFalse(response.completedAt is "", "completedAt should not be empty");
  test:assertFalse(response.startedAt is "", "startedAt should not be empty");
}

@test:Config {}
function testDeleteObjectsOrdersByOrderId() returns error? {
  string orderId = "10";

  http:Response response = check baseClient->/orders/[orderId].delete();
  test:assertTrue(response.statusCode == 204);
}

@test:Config {}
function testPatchObjectsOrdersByOrderId() returns error? {
  string orderId = "394961395351";
  SimplePublicObjectInput payload = 
    {
    "objectWriteTraceId": "string",
    "properties": {
      "hs_lastmodifieddate": "2024-03-27T20:03:05.890Z",
      "hs_shipping_tracking_number": "123098521091"
    }
  };
  SimplePublicObject response = check baseClient->/orders/[orderId].patch(payload = payload);

  test:assertFalse(response?.id is "", "id should not be empty");
  test:assertFalse(response?.createdAt is "", "creation time should not be empty");
  test:assertFalse(response?.updatedAt is "", "updated time should not be empty");

}

@test:Config {}
function testGetObjectsOrdersByOrderId() returns error?{
  string orderId = "394961395351";

  SimplePublicObjectWithAssociations response = check baseClient->/orders/[orderId];
  test:assertFalse(response?.createdAt is "", "creation time should not be empty");
  test:assertFalse(response?.updatedAt is "", "updated time should not be empty");

}

@test:Config {}
function  testPostordersBatchUpsert() returns error?{
  BatchInputSimplePublicObjectBatchInputUpsert payload = {
    "inputs": [
      {
        "idProperty": "string",
        "objectWriteTraceId": "string",
        "id": "21",
        "properties": {
          "additionalprop1": "string",
          "additionalprop2": "string",
          "additionalprop3": "string"
        }
      }
    ]
  };
  BatchResponseSimplePublicUpsertObject|BatchResponseSimplePublicUpsertObjectWithErrors response = check baseClient->/orders/batch/upsert.post(payload = payload);
  test:assertTrue(true);
  io:println(response);
  }

@test:Config {}
function  testPostOrdersBatchCreate() returns error?{

  BatchInputSimplePublicObjectInputForCreate payload = {
  "inputs": [
    {
      "associations": [
        {
          "types": [
            {
              "associationCategory": "HUBSPOT_DEFINED",
              "associationTypeId": 0
            }
          ],
          "to": {
            "id": "21"
          }
        }
      ],
      "objectWriteTraceId": "34",
      "properties": {
        "additionalprop1": "string",
        "additionalprop2": "string",
        "additionalprop3": "string"
      }
    }
  ]
};
  BatchResponseSimplePublicObject response = check baseClient->/orders/batch/create.post(payload = payload);
  test:assertFalse(response.completedAt is "", "completedAt should not be empty");
  test:assertFalse(response.startedAt is "", "startedAt should not be empty");
}

@test:Config {}
function testPostObjectsOrdersBatchUpdate() returns error?{
  BatchInputSimplePublicObjectBatchInput payload = 
    {
      "inputs": [
        {
          "idProperty": "string",
          "objectWriteTraceId": "string",
          "id": "21",
          "properties": {
            "additionalprop1": "string",
            "additionalprop2": "string",
            "additionalprop3": "string"
          }
        }
      ]
    };
  BatchResponseSimplePublicObject|BatchResponseSimplePublicObjectWithErrors|error response = check baseClient->/orders/batch/update.post(payload = payload);
  test:assertTrue(true);
}

@test:Config {}
function  testPostObjectsOrders() returns error? {

  SimplePublicObjectInputForCreate payload = 
    {
      "associations": [
    {
      "to": {
        "id": "31440573867"
      },
      "types": [
        {
          "associationCategory": "HUBSPOT_DEFINED",
          "associationTypeId": 512
        }
      ]
    }
  ],
      "objectWriteTraceId": null,
      "properties": {
        "hs_order_name": "Camping supplies",
    "hs_currency_code": "USD",
    "hs_source_store": "REI - Portland",
    "hs_fulfillment_status": "Packing",
    "hs_shipping_address_city": "Portland",
    "hs_shipping_address_state": "Maine",
    "hs_shipping_address_street": "123 Fake Street"
      }
    };
  SimplePublicObject|error response = check baseClient->/orders.post(payload = payload);
  test:assertTrue(true);
}

@test:Config {}
function  testGetObjectsOrders() returns error? {
  CollectionResponseSimplePublicObjectWithAssociationsForwardPaging|error response = check baseClient->/orders;
  test:assertTrue(true);
}

@test:Config {}
function  testPostOrdersBatchArchive() returns error?{
  BatchInputSimplePublicObjectId payload = {
    "inputs": [
      {
        "id": "string"
      }
    ]
  };
  http:Response|error response = check baseClient->/orders/batch/archive.post(payload = payload);
  test:assertTrue(true);
}
