# Azure Functions - Hello world

This example demonstrates how to write a simple echo function in Azure Functions.

In Ballerina, triggers are represented by listeners. When the `af:HttpListener` gets attached to the service, it implies that the function is an HTTP Trigger. The resource method behaves exactly the same as a service written from `ballerina/http`. It supports the `http:Payload` and `http:Header` annotations for parameters. Input binding annotations can be used to annotate parameters to make use of external services in Azure. If no annotations are specified for a parameter, it is identified as a query parameter.

Output bindings are defined in the return type definition. For services with the `HttpListener` attachment, `HttpOutput` is the default output binding. You can override the default behavior by specifying them explicitly in the return type. 

In the code sample shown above, it has an empty service path and resource path named `hello`. The accessor is `get`. It expects a request with a query parameter for the field name. The required artifact generation and data binding will be handled by the `ballerinax/azure_functions` package automatically.

For more information, see the [Azure deployment guide](https://ballerina.io/learn/azure-functions/).

## Set up the prerequisites

For instructions, see [Set up the prerequisites](https://ballerina.io/learn/azure-functions/#set-up-the-prerequisites).

## Write the function

Follow the steps below to write the function.

1. Execute the command below to create a new Ballerina package.

::: out bal_new.out :::

2. Replace the content of the generated Ballerina file with the content below.

::: code azure_functions_hello_world.bal :::

## Build the function

Execute the command below to generate the Azure Functions artifacts.

::: out bal_build.out :::

## Deploy the function

Execute the Azure CLI command given by the compiler to create and publish the functions by replacing `<function_app_name>` with your respective function app name.

::: out az_deploy.out :::

## Invoke the function

Execute the command below to invoke the function by replacing `<function_app_name>` with your respective function app name.

::: out execute_function.out :::
