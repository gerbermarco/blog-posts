# Deploy Entra ID resources declaratively using Azure Bicep

This documentation outlines the steps and resources required to integrate Microsoft Graph functionalities for managing Azure resources, including managed identities, security groups, storage accounts, and role assignments. This configuration aims at assigning a specific role to a managed identity, allowing it to read data from a storage blob through a group membership.

## Overview

The implementation involves creating a user-assigned managed identity, a security group within Microsoft Graph, a storage account, and assigning the "Storage Blob Data Reader" role to the security group. This setup is particularly useful for scenarios where an application or service running under a managed identity requires access to read data from Azure Blob Storage without direct and manual role assignments.

## Parameters

- `managedIdentityName`: The name of the managed identity to be created.
- `storageAccountName`: The name of the Azure Storage account.
- `appRoleDefinitionId`: The ID of the role definition, in this case, "Storage Blob Data Reader".
- `groupDisplayName`: The display name of the security group to be created. This is also used to generate a unique name for the group.

## Variables

- `groupUniqueName`: A normalized version of `groupDisplayName` to ensure uniqueness.
- `roleAssignmentName`: A globally unique identifier for the role assignment, generated using the `groupUniqueName`, `appRoleDefinitionId`, and the resource group ID.

## Resources

### Managed Identity

- **Resource Type**: `Microsoft.ManagedIdentity/userAssignedIdentities`
- **API Version**: `2023-07-31-preview`
- **Properties**:
  - `name`: Name of the managed identity.
  - `location`: Location of the resource group.

### Security Group

- **Resource Type**: `Microsoft.Graph/groups`
- **API Version**: `v1.0`
- **Properties**:
  - `displayName`: Display name of the security group.
  - `uniqueName`: Unique name derived from the display name.
  - `mailEnabled`: Specifies that the group is not mail-enabled.
  - `mailNickname`: A nickname for the group, using `groupUniqueName`.
  - `securityEnabled`: Indicates that this is a security group.
  - `members`: Array containing the principal ID of the managed identity.

### Storage Account

- **Resource Type**: `Microsoft.Storage/storageAccounts`
- **API Version**: `2023-04-01`
- **Properties**:
  - `name`: Name of the storage account.
  - `location`: Location of the resource group.
  - `sku`: SKU name set to `Standard_LRS`.
  - `kind`: Set to `StorageV2`.

### Role Assignment

- **Resource Type**: `Microsoft.Authorization/roleAssignments`
- **API Version**: `2022-04-01`
- **Properties**:
  - `name`: Globally unique identifier for the role assignment.
  - `principalId`: ID of the security group.
  - `roleDefinitionId`: Resource ID of the role definition.

## Deployment steps

To deploy the resources as described in the documentation, follow these steps. These steps assume you have the Azure CLI installed and have a Bicep file named `main.bicep` that contains the described resources.

### 1. Login to Azure

First, you need to login to your Azure account via the Azure CLI. This step authenticates your session and allows you to manage your Azure resources from the command line.

```bash
az login
```

After running this command, follow the instructions to complete the login process.

### 2. Set Azure Subscription

Once logged in, you need to specify which Azure subscription you want to use for the deployment. Replace `<subscriptionId>` with your actual subscription ID.

```bash
az account set --subscription <subscriptionId>
```

### 3. Deploy Resources

Finally, to deploy the resources, you will use the `az deployment group create` command. This command deploys all resources defined in your Bicep file to the specified resource group. In this example, the resource group is named `d-rgr-graph-demo`.

Replace the path to the Bicep file if it's located in a different directory or has a different name.

```bash
az deployment group create -g d-rgr-graph-demo -f .\main.bicep
```

## Conclusion

This setup facilitates secure and scoped access to Azure Blob Storage for applications requiring read-only data access. By leveraging Microsoft Graph and Azure Resource Manager templates, developers can automate the provisioning and management of Azure resources with fine-grained access controls.