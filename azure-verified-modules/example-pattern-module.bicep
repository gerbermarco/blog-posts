targetScope = 'subscription'

// PARAMETERS
param location string = 'switzerlandnorth'
param resourceGroupName string = 'demo-pattern-module'
param envNameShort string = 'demoptn'

// RESOURCES
resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  location: location
  name: resourceGroupName
}

// MODULES
module aiPlatformBaseline 'br/public:avm/ptn/ai-platform/baseline:0.3.0' = {
  scope: rg
  name: envNameShort
  params: {
    name: envNameShort
    virtualMachineConfiguration: {
      adminUsername: '<adminUsername>'
      adminPassword: '<adminPassword>'
      encryptionAtHost: false
    }
  }
}
