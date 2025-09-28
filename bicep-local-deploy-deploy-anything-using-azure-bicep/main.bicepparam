using 'main.bicep'

param location = '' // <-- Update value
param subscriptionId = '' // <-- Update value
param rgName = 'rg-bicep-local-lab'
param storageAccountName = 'st${uniqueString(subscriptionId, rgName)}'
