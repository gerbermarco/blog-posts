// Functions
func getResourceName(isProduction bool, resourceAbbreviation string, serviceName string) string => '${isProduction ? 'p' : 't'}-${resourceAbbreviation}-${serviceName}'
func getSkuName(allocationMethod string) string => allocationMethod =~ 'Static' ? 'Standard' : 'Basic'

// Parameters
param location string = 'switzerlandnorth'
param isProduction bool = true
param resourceAbbreviation string = 'pip'
param serviceName string = 'demo'
param pipAllocationMethod string = 'Static'

// Resources
resource pip 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: getResourceName(isProduction, resourceAbbreviation, serviceName)
  location: location
  properties: {
    publicIPAllocationMethod: pipAllocationMethod
  }
  sku: {
    name: getSkuName(pipAllocationMethod)
  }
}
