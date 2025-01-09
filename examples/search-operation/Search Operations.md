# Search Operations Example for HubSpot Orders

This Ballerina example demonstrates how to perform search operations on orders in HubSpot using the `ballerinax/hubspot.crm.commerce.orders` connector.

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

- **`main()`:** Initializes the HubSpot client and triggers search operations.
- **`handleSearchOperations()`:** Manages the search operation for orders.
- **`searchOrders()`:** Searches for orders based on specified criteria.

## Dependencies

- `ballerina/io`
- `ballerina/oauth2`
- `ballerinax/hubspot.crm.commerce.orders`

## Notes

- Ensure the `Config.toml` file is properly configured with your HubSpot API credentials.
- Dependencies should be set up in your project.

## License

Licensed under the Apache License 2.0. See [LICENSE](http://www.apache.org/licenses/LICENSE-2.0) for details.
