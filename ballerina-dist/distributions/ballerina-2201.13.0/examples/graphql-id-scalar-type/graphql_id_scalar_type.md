# GraphQL service - ID scalar type

The Ballerina `graphql` module provides support for the `ID` scalar type in GraphQL. The `ID` type is used to represent unique identifiers within a GraphQL schema. It is a built-in scalar type that can be utilized to define input parameters for GraphQL fields. Applying the `@graphql:ID` annotation to specific fields indicates that they correspond to the GraphQL `ID` scalar type. Consequently, the generated schema will display the field type as `ID` regardless of the actual type of the field.

::: code graphql_id_scalar_type.bal :::

Run the service by executing the following command.

::: out graphql_id_scalar_type.server.out :::

Send the following document to the GraphQL endpoint to test the service.

::: code graphql_id_scalar_type.graphql :::

To send the document, execute the following cURL command in a separate terminal.

::: out graphql_id_scalar_type.client.out :::

>**Tip:** You can invoke the above service via the [GraphQL client](/learn/by-example/graphql-client-query-endpoint/).

## Related links
- [`graphql` module - API documentation](https://lib.ballerina.io/ballerina/graphql/latest)
- [GraphQL ID scalar type - Specification](/spec/graphql/#415-id)
