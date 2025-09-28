targetScope = 'local'

extension az
extension http

param location string
param subscriptionId string
param rgName string
param storageAccountName string

var publicIp = json(publicIpRequest.body).ip

resource publicIpRequest 'HttpRequest' = {
  uri: 'https://api.ipify.org?format=json'
  format: 'raw'
}

module rg 'modules/resource-group.bicep' = {
  scope: subscription(subscriptionId)
  params: {
    rgName: rgName
    location: location
  }
}

module sto 'modules/storage-account.bicep' = {
  scope: resourceGroup(subscriptionId, rgName)
  dependsOn: [
    rg
  ]
  params: {
    location: location
    storageAccountName: storageAccountName
    accessPublicIp: publicIp
  }
}

output publicIpResponse string = publicIp
