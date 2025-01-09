# Order Management Example for HubSpot Orders

This Ballerina example demonstrates how to manage orders in HubSpot using the `ballerinax/hubspot.crm.commerce.orders` connector. The example covers creating, reading, updating, and deleting orders.

## Prerequisites

- **Ballerina Swan Lake:** Install from [here](https://ballerina.io/downloads/).
- **HubSpot Developer Account:** Obtain API credentials (Client ID, Client Secret, Refresh Token).

## Setup

1. Create a `Config.toml` file with your HubSpot credentials:

    ```toml
    clientId = "<Your Client ID>"
    clientSecret = "<Your Client Secret>"
    refreshToken = "<Your Refresh Token>"
    ```

2. Place the `Config.toml` in the root directory of this example.

## Running the Example

Navigate to this example's directory and execute:

* To build the example:

    ```bash
    bal build
    ```

* To run the example:

    ```bash
    bal run
    ```

## Code Overview

- **`main()`:** Initializes the HubSpot client and triggers order management operations.
- **`handleOrderManagement()`:** Manages the lifecycle of an order (create, read, update, delete).
- **`createOrder()`:** Creates a new order in HubSpot.
- **`readOrder()`:** Retrieves details of a specific order.
- **`updateOrder()`:** Updates properties of an existing order.
- **`deleteOrder()`:** Deletes an order from HubSpot.

## Dependencies

- `ballerina/io`
- `ballerina/oauth2`
- `ballerinax/hubspot.crm.commerce.orders`

## Notes

- Ensure the `Config.toml` file is properly configured with your HubSpot API credentials.
- Dependencies should be set up in your project.

## License

Licensed under the Apache License 2.0. See [LICENSE](http://www.apache.org/licenses/LICENSE-2.0) for details.
