## Module Overview

This module provides the Ballerina OpenAPI tooling, which will make it easy to start the development of a service documented in an OpenAPI contract in Ballerina by generating the Ballerina service and client skeletons.

The OpenAPI tools provide the following capabilities.

1. Generate the Ballerina service or client code for a given OpenAPI definition.
2. Export the OpenAPI definition of a Ballerina service.
3. Validate the service implementation of a given OpenAPI contract.

The `openapi` command in Ballerina is used for OpenAPI to Ballerina and Ballerina to OpenAPI code generations.
Code generation from OpenAPI to Ballerina can produce `ballerina service stubs` and `ballerina client stubs`.
The OpenAPI compiler plugin will allow you to validate a service implementation against an OpenAPI contract during
the compile time.
This plugin ensures that the implementation of a service does not deviate from its OpenAPI contract.

### OpenAPI to Ballerina
#### Generate Service and Client Stub from an OpenAPI Contract

```bash
bal openapi -i <openapi-contract-path> 
               [--tags: tags list]
               [--operations: operationsID list]
               [--mode service|client ]
               [(-o|--output): output file path]
```
Generates both the Ballerina service and Ballerina client stubs for a given OpenAPI file.

This `-i <openapi-contract-path>` parameter of the command is mandatory. It will get the path to the
OpenAPI contract file (i.e., `my-api.yaml` or `my-api.json`) as an input.

You can give the specific tags and operations that you need to document as services without documenting all the operations using these optional `--tags` and `--operations` commands.

The `(-o|--output)` is an optional parameter. You can use this to give the output path of the generated files.
If not, it will take the execution path as the output path.

##### Modes
If you want to generate a service only, you can set the mode as `service` in the OpenAPI tool.

```bash
    bal openapi -i <openapi-contract-path> --mode service [(-o|--output) output file path]
```

If you want to generate a client only, you can set the mode as  `client` in the OpenAPI tool.
This client can be used in client applications to call the service defined in the OpenAPI file.

```bash
    bal openapi -i <openapi-contract-path> --mode client [(-o|--output) output file path]
```

### Ballerina to OpenAPI
#### Service to OpenAPI Export
```bash
    bal openapi -i <ballerina-file-path> 
               [(-o|--output) output openapi file path]
```
Export the Ballerina service to an  OpenAPI Specification 3.0 definition. For the export to work properly,
the input Ballerina service should be defined using the basic service and resource-level HTTP annotations.
If you need to document an OpenAPI contract for only one given service, then use this command.
```bash
    bal openapi -i <ballerina-file-path> (-s | --service) <service-name>
```

### Using Annotations in Ballerina OpenAPI Conversion
### `@openapi:ServiceInfo` Annotation
The `@openapi:ServiceInfo` annotation is used to specify metadata about the Ballerina service during OpenAPI
generation.
The following is an example of the annotation usage.
```ballerina
@openapi:ServiceInfo {
    contract: "/path/to/openapi.json",
    tags: ["store"],
    operations: ["op1", "op2"],
    failOnErrors: true,
    excludeTags: ["pets", "user"],
    excludeOperations: ["op1", "op2"],
    title: "store",
    version: "0.1.0",
    description: "API system description",
    email: "mark@abc.com",
    contactName: "ABC company",
    contactURL: "http://mock-api-contact",
    termsOfService: "http://mock-api-doc",
    licenseName: "ABC",
    licenseURL: "http://abc-license.com",
    embed: true // (default value => false)
}
service /greet on new http:Listener(9090) {
    ...
}
```
#### Annotation Supports for the Following Attributes:
- **Contract** (Optional) : **string**  :
  Here, you can provide a path to the OpenAPI contract as a string and the OpenAPI file can either be `.yaml` or `.json`.
  This is a required attribute.

- **Tag** (Optional) : **string[]?**     :
  The compiler will only validate resources against operations, which are tagged with a tag specified in the list.
  If not specified, the compiler will validate resources against all the operations defined in the OpenAPI contract.

- **Operations** (Optional): **string[]?**  :
  Should contain a list of operation names that need to be validated against the resources in the service.
  If not specified, the compiler will validate resources against all the operations defined in the OpenAPI contract. If both tags and operations are defined, it will validate against the union set of the resources.

- **ExcludeTags** (Optional) : **string[]?**    :
  This feature is for users to store the tag. It does not need to be validated.
  At the same time, the `excludeTag` and `Tag` cannot store and the plugin will generate warning messages regarding
  it.

- **ExcludeOperations** (Optional) : **string[]?**  :
  This feature is for users to store the operations that do not need to be validated.
  At the same time, the `excludeOperations` and  `Operations` can not store and they will generate warning messages.
  The `Tag` feature can store with `excludeOperations`. Then, all the tag operations will be validated except the `exclude`
  operations.

- **FailOnErrors** (Optional) : **boolean value**   :
  If you need to turn off the validation, add this to the annotation with the value as `false`.

- **title** (Optional) :
  This feature adds the title of the `info` section in the generated OpenAPI contract.

- **version** (Optional) :
  This feature adds the version of the `info` section in the generated OpenAPI contract.

- **description** (Optional) :
  This feature can be used to add the description of the `info` section in the generated OpenAPI contract. A brief
  description of the API, outlining its purpose, features, and any other relevant details that help users understand
  what the API does and how to use it.

- **email** (Optional) :
  This feature can be used to add the email address to the `contact` section in the OpenAPI contract. This describes
  email details for the API provider or support.

- **contactName** (Optional) :
  Users can use this attribute to add the name of the person or organization responsible for the API.

- **contactURL** (Optional) :
  Users can use this attribute to add the URL to a web page with more information about the API, the provider, or support.

- **termsOfService** (Optional) :
  Users can use this to add the URL details to the terms of service for the API.

- **licenseName** (Optional) :
  Users can use this to add the name of the license under which the API is provided.

- **licenseURL** (Optional) :
  Users can use this to add the URL details regarding the full text of the license.

- **embed** (Optional) : **boolean value** :
  This feature turns on generating OpenAPI documentation for the service for introspection endpoint support when used
  with `true` in the annotation.

### `@openapi:ResourceInfo` Annotation
The `@openapi:ResourceInfo` annotation provides metadata for specific resource functions.
The following is an example of the Ballerina resource function with the OpenAPI annotation.
```ballerina
@openapi:ResourceInfo {
    operationId: "createStoreData",
    summary: "API for adding store amount",
    tags: ["retail", "rate"]
}
resource function post store(Inventory payload) returns string? {
        // logic here
}
```
Following is the generated OpenAPI contract with the given details
```yaml
...
paths:
  /store:
    post:
      tags:
      - retail
      - rate
      summary: API for adding store amount
      operationId: createStoreData
      requestBody:
        content:
          application/json:
            schema:
...
```
#### Annotation Supports for the Following Attributes:
- **operationId** (Optional) :
  Users can use this to update opearation Id in particular operation in OpenAPI contract.

- **summary** (Optional) :
  This attribute helps users to add summary for the particular operation in the OpenAPI contract.

- **tags** (Optional) :
  This attribute specifies the tag in the list map to the tags list in operation.

### `@openapi:Example` Annotation
The `@openapi:Example` annotation renders examples in the OpenAPI contract. It can be attached to parameters,
record types, or record fields.
The following is an example for Ballerina object level example mapping.
```ballerina
@openapi:Example {
  value: {
    id: 10,
    name: "Jessica Smith"
  }
}
type User record {
  int id;
  string name
}
```
Following is the generated OpenAPI contract with the given details.
```yaml
...
components:
  schemas:
    User:
      type: object
      properties:
        id:
          type: integer
        name:
          type: string
      example:
        id: 10
        name: Jessica Smith
...
```

### Samples for OpenAPI Commands
#### Generate Service and Client Stub from OpenAPI
```bash
    bal openapi -i hello.yaml
```

This will generate a Ballerina service and client stub for the `hello.yaml` OpenAPI contract named `hello-service`
and client named `hello-client`. The above command can be run from within anywhere on the execution path.
It is not mandatory to run it from inside the Ballerina project.

Output:
```bash
The service generation process is complete. The following files were created.
-- hello-service.bal
-- client.bal
-- types.bal
```
#### Generate an OpenAPI Contract from a Service

 ```bash
    bal openapi -i modules/helloworld/helloService.bal
  ```
This will generate the OpenAPI contracts for the Ballerina services, which are in the `hello.bal` Ballerina file.
 ```bash 
    bal openapi -i modules/helloworld/helloService.bal (-s | --service) helloworld
  ```
This command will generate the `helloworld-openapi.yaml` file that is related to the `helloworld` service inside the
`helloService.bal` file.
 ```bash
    bal openapi -i modules/helloworld/helloService.bal --json
  ```
This `--json` option can be used with the Ballerina to OpenAPI command to generate the `helloworld-openapi.json` file
instead of generating the YAML file.
