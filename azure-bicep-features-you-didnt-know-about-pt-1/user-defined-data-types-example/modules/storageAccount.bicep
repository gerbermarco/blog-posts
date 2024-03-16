// PARAMETERS
param location string
param storageAccountName string
param sku object
@allowed([
  'BlobStorage'
  'BlockBlobStorage'
  'FileStorage'
  'Storage'
  'StorageV2'
])
param kind string
param allowBlobPublicAccess bool
param supportsHttpsTrafficOnly bool

// RESOURCES
resource sto 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageAccountName
  location: location
  sku: sku
  kind: kind
  properties: {
    accessTier: 'Hot'
    allowBlobPublicAccess: allowBlobPublicAccess
    supportsHttpsTrafficOnly: supportsHttpsTrafficOnly
  }
}
