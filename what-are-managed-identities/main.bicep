// PARAMETERS
param location string = resourceGroup().location
param automationAccountName string = 'd-aut-blog-mid-01'

// RESOURCE DEPLOYMENTS
// Automation Account
resource automationAccount 'Microsoft.Automation/automationAccounts@2022-08-08' = {
  name: automationAccountName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    sku: {
      name: 'Free'
    }
  }
}

// Automation Runbook
resource runbook 'Microsoft.Automation/automationAccounts/runbooks@2022-08-08' = {
  name: 'runbook01'
  parent: automationAccount
  location: location
  properties: {
    runbookType: 'PowerShell'
    publishContentLink: {
      uri: 'https://raw.githubusercontent.com/gerbermarco/blog-posts/main/what-are-managed-identities/runbook-content.ps1'
    }
  }
}
