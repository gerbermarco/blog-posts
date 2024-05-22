provider microsoftGraph

// Parameters
param managedIdentityName string = 'd-id-graph-demo'
param storageAccountName string = 'dstographdemo6294'
param appRoleDefinitionId string = '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1' // Storage Blob Data Reader
param groupDisplayName string = '${storageAccountName}-StorageBlobDataReader'

// Variables
var groupUniqueName = toLower(replace(groupDisplayName, ' ', ''))
var roleAssignmentName = guid(groupUniqueName, appRoleDefinitionId, resourceGroup().id)

// Resources
resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-07-31-preview' = {
  name: managedIdentityName
  location: resourceGroup().location
}

resource securityGroup 'Microsoft.Graph/groups@v1.0' = {
  displayName: groupDisplayName
  uniqueName: groupUniqueName
  mailEnabled: false
  mailNickname: groupUniqueName
  securityEnabled: true
  members: [
    managedIdentity.properties.principalId
  ]
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-04-01' = {
  name: storageAccountName
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: roleAssignmentName
  properties: {
    principalId: securityGroup.id
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', appRoleDefinitionId)
  }
}
