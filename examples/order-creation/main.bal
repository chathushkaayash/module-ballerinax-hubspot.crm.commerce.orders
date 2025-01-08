import ballerinax/hubspot.crm.commerce.orders as orders;
import ballerina/oauth2;
import ballerina/http;
import ballerina/io;

configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

public function main() returns error?{
    // Create a new client using the provided configuration
    orders:ConnectionConfig config = {
        auth: {
            clientId: clientId,
            clientSecret: clientSecret,
            refreshToken: refreshToken,
            credentialBearer: oauth2:POST_BODY_BEARER
        }
    };

    final orders:Client baseClient = check new orders:Client(config, serviceUrl = "https://api.hubapi.com/crm/v3/objects"); 
    io:println(baseClient);
    io:println("Client created successfully");

    // Batch Api - Achieve a batch of orders by ID
    orders:BatchInputSimplePublicObjectId achieveBatchRequest = {
        "inputs": [
        {
            "id": "10"
        }
        ]
    };
    http:Response achieveBatchResponse = check baseClient->/orders/batch/archive.post(achieveBatchRequest);
    io:println("Batch Api - Batch of orders archived successfully: " , achieveBatchResponse.statusCode);
    io:println(achieveBatchResponse);

    // Batch Api - Create a batch of orders
    orders:BatchInputSimplePublicObjectInputForCreate batchOrderCreationRequest = {
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
    };
    orders:BatchResponseSimplePublicObject batchOrderCreationResponse = check baseClient->/orders/batch/create.post(batchOrderCreationRequest);
    io:println("Batch Api - Batch of orders created successfully: " , batchOrderCreationResponse.status);
    io:println(batchOrderCreationResponse);

    // Batch Api - Create or update a batch of orders by unique property values
    orders:BatchInputSimplePublicObjectBatchInputUpsert batchOrderCreationByPropertyRequest = {
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
    };
    orders:BatchResponseSimplePublicUpsertObject | orders:BatchResponseSimplePublicUpsertObjectWithErrors batchOrderCreationByPropertyResponse = check baseClient->/orders/batch/upsert.post(batchOrderCreationByPropertyRequest);
    io:println("Batch Api - Batch of orders created or updated successfully: " , batchOrderCreationByPropertyResponse.status);
    io:println(batchOrderCreationByPropertyResponse);


    // Batch Api - Read a batch of orders by internal ID, or unique property values
    orders:BatchReadInputSimplePublicObjectId batchOrderReadRequest = {
        "propertiesWithHistory": [
            "hs_lastmodifieddate"
        ],
        "inputs": [
            {
            "id": "394961395351"
            }
        ],
        "properties": ["hs_lastmodifieddate", "hs_createdate", "hs_object_id","updatedAt"]
    };
    orders:BatchResponseSimplePublicObject | orders:BatchResponseSimplePublicObjectWithErrors batchOrderReadResponse = check baseClient->/orders/batch/read.post(batchOrderReadRequest);
    io:println("Batch Api - Batch of orders read successfully: " , batchOrderReadResponse.status);
    io:println(batchOrderReadResponse);

    // Batch Api - Update a batch of orders
    orders:BatchInputSimplePublicObjectBatchInput batchOrderUpdateRequest = 
        {
        "inputs": [
            {
            //   "idProperty": "Unique ID for System A",
            "id": "395267361897",
            "properties": {
                "hs_currency_code": "USD"
            }
            }
        ]
    };
    orders:BatchResponseSimplePublicObject|orders:BatchResponseSimplePublicObjectWithErrors batchOrderUpdateResponse = check baseClient->/orders/batch/update.post(batchOrderUpdateRequest);
    io:println("Batch Api - Batch of orders updated successfully: " , batchOrderUpdateResponse.status);
    io:println(batchOrderUpdateResponse);

    // Basic Api - Read a list of orders
    orders:CollectionResponseSimplePublicObjectWithAssociationsForwardPaging listOfOrdersResponse = check baseClient->/orders;
    io:println("Basic Api - List of orders read successfully: " , listOfOrdersResponse.results.length(), " orders found.");
    io:println(listOfOrdersResponse);
    

    // Basic Api - Read an order by ID
    string orderId = "394961395351";
    orders:SimplePublicObjectWithAssociations getOrderByIdResponse = check baseClient->/orders/[orderId];
    io:println("Basic Api - Order read successfully: " , getOrderByIdResponse.id);
    io:println(getOrderByIdResponse);

    // Basic Api - Create a order with the given properties and return a copy of the object, including the ID
    orders:SimplePublicObjectInputForCreate orderCreationRequest = 
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
    orders:SimplePublicObject orderCreationResponse = check baseClient->/orders.post(orderCreationRequest);
    io:println("Basic Api - Order created successfully: " , orderCreationResponse.id);
    io:println(orderCreationResponse);

    // Basic Api - Perform a partial update of an Object
    orders:SimplePublicObjectInput orderUpdateRequest = 
        {
        "objectWriteTraceId": "10",
        "properties": {
        "hs_lastmodifieddate": "2024-03-27T20:03:05.890Z",
        "hs_shipping_tracking_number": "123098521091"
        }
    };
    orders:SimplePublicObject orderUpdateResponse = check baseClient->/orders/[orderId].patch(orderUpdateRequest);
    io:println("Basic Api - Order updated: ", orderUpdateResponse.id);
    io:println(orderUpdateResponse);

    // Basic Api - Move an order to recycle bin
    string orderDeleteId = "10";
    http:Response orderDeleteResponse = check baseClient->/orders/[orderDeleteId].delete();
    io:println("Basic Api - Order deleted with status: ", orderDeleteResponse.statusCode);
    io:println(orderDeleteResponse);

    // Search for orders
    orders:PublicObjectSearchRequest orderSearchRequest = {
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
    orders:CollectionResponseWithTotalSimplePublicObjectForwardPaging orderSearchResponse = check baseClient->/orders/search.post(orderSearchRequest);
    if (orderSearchResponse.total == 0) {
        io:println("Search Api - No orders found.");
        io:println(orderSearchResponse);
    }else {
        io:println("Search Api - Orders found.");
        io:println(orderSearchResponse);
    }
}