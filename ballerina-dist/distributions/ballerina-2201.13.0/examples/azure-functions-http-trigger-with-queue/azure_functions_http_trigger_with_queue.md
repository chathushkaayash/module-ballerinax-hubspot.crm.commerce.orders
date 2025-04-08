# Azure Functions - HTTP trigger with queue

This example demonstrates using an HTTP trigger to invoke an Azure function with multiple output bindings to return the HTTP response and queue output binding to write an entry to a queue.

For more information, see the [Azure Functions deployment guide](https://ballerina.io/learn/azure-functions/).

## Set up the prerequisites

1. Set up the [general prerequisites](https://ballerina.io/learn/azure-functions/#set-up-the-prerequisites).
2. In the AWS Portal, click **Storage accounts** to create a queue to hold the outputs of the function.
2. From the list, click on the storage account entry that corresponds with your function app.
3. Click **Queues** in the sidebar, and click **+ Queue**.
4. Enter a name in the **Add queue** pop-up, and click **Add**.
   >**Note:** For the **Queue name**, enter the same value of the `queueName` property in the `QueueOutput` annotation in the [Ballerina source below](https://ballerina.io/learn/by-example/azure-functions-trigger/#write-the-function)

## Write the function

Follow the steps below to write the function.

1. Execute the command below to create a new Ballerina package.

::: out bal_new.out :::

2. Replace the content of the generated Ballerina file with the content below.

::: code azure_functions_http_trigger_with_queue.bal :::

## Build the function

Execute the command below to generate the Azure Functions artifacts.

::: out bal_build.out :::

## Deploy the function

Execute the Azure CLI command given by the compiler to create and publish the functions by replacing `<function_app_name>` with your respective function app name.

## Invoke the function

Execute the command below by replacing `<function_app_name>` with your respective function app name to invoke the function.

::: out execute_function.out :::

>**Tip:** Refresh the page of the `people` queue in the Azure portal and view the entry added with the message text: `Jack is 21 years old.`
