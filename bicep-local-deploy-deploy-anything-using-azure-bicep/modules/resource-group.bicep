targetScope = 'subscription'

extension az

param rgName string
param location string

resource rg 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: rgName
  location: location
}
