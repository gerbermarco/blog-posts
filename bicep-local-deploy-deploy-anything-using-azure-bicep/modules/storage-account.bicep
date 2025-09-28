targetScope = 'resourceGroup'

extension az

param location string
param storageAccountName string
param accessPublicIp string

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    networkAcls: {
      defaultAction: 'Deny'
      ipRules: [
        {
          value: accessPublicIp
          action: 'Allow'
        }
      ]
    }
  }
}
