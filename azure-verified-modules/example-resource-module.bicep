targetScope = 'subscription'

// PARAMETERS
param location string = 'switzerlandnorth'
param resourceGroupName string = 'demo-resource-module'
param keyVaultName string = 'demo-kva'
param roleAssignments array = [
  {
    principalId: '<objectId of the user or service principal>'
    roleDefinitionIdOrName: 'Key Vault Secrets User'
  }
]

// RESOURCES
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  location: location
  name: resourceGroupName
}

// MODULES
module kva 'br/public:avm/res/key-vault/vault:0.7.1' = {
  scope: rg
  name: keyVaultName
  params: {
    location: location
    name: keyVaultName
    roleAssignments: roleAssignments
    lock: {
      name: 'Set by code'
      kind: 'CanNotDelete'
    }
  }
}
