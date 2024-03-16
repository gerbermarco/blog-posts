targetScope = 'subscription'

// PARAMETERS
param location string = 'switzerlandnorth'
param resourceGroupName string = 'demo-udef-datatypes'

param storageAccount01 storageAccountDefinition = {
  sku: {
    name: 'Standard_RAGRS'
    tier: 'Standard'
  }
  kind: 'BlobStorage'
  allowBlobPublicAccess: true
  storageAccountName: 'demoudefdatatypes01'
  supportsHttpsTrafficOnly: true
}

param storageAccount02 storageAccountDefinition = {
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'BlobStorage'
  allowBlobPublicAccess: false
  storageAccountName: 'demoudefdatatypes02'
  supportsHttpsTrafficOnly: true
}

param storageAccount03 storageAccountDefinition = {
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'BlobStorage'
  allowBlobPublicAccess: false
  storageAccountName: 'demoudefdatatypes03'
  supportsHttpsTrafficOnly: true
}

// RESOURCES
resource rg 'Microsoft.Resources/resourceGroups@2023-07-01' = {
  name: resourceGroupName
  location: location
}

// MODULES
module sto01 'modules/storageAccount.bicep' = {
  scope: rg
  name: storageAccount01.storageAccountName
  params: {
    location: location
    storageAccountName: storageAccount01.storageAccountName
    kind: storageAccount01.kind
    sku: storageAccount01.sku
    allowBlobPublicAccess: storageAccount01.allowBlobPublicAccess
    supportsHttpsTrafficOnly: storageAccount01.supportsHttpsTrafficOnly
  }
}

module sto02 'modules/storageAccount.bicep' = {
  scope: rg
  name: storageAccount02.storageAccountName
  params: {
    location: location
    storageAccountName: storageAccount02.storageAccountName
    kind: storageAccount02.kind
    sku: storageAccount02.sku
    allowBlobPublicAccess: storageAccount02.allowBlobPublicAccess
    supportsHttpsTrafficOnly: storageAccount02.supportsHttpsTrafficOnly
  }
}

module sto03 'modules/storageAccount.bicep' = {
  scope: rg
  name: storageAccount03.storageAccountName
  params: {
    location: location
    storageAccountName: storageAccount03.storageAccountName
    kind: storageAccount03.kind
    sku: storageAccount03.sku
    allowBlobPublicAccess: storageAccount03.allowBlobPublicAccess
    supportsHttpsTrafficOnly: storageAccount03.supportsHttpsTrafficOnly
  }
}

// DATA TYPES
type storageAccountDefinition = {
  @minLength(3)
  @maxLength(24)
  @description('Name of the storage account')
  storageAccountName: string

  @description('The SKU name. Required for account creation.')
  sku: {
    name: 'Premium_LRS' | 'Premium_ZRS' | 'Standard_GRS' | 'Standard_GZRS' | 'Standard_LRS' | 'Standard_RAGRS' | 'Standard_RAGZRS' | 'Standard_ZRS'
    tier: 'Standard' | 'Premium'
  }

  @description('Indicates the type of storage account.')
  kind: 'BlobStorage' | 'BlockBlobStorage' | 'FileStorage' | 'Storage' | 'StorageV2'

  @description('Allow or disallow public access to all blobs or containers in the storage account.')
  allowBlobPublicAccess: bool
  supportsHttpsTrafficOnly: bool
}
