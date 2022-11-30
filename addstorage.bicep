param location string = resourceGroup().location
param stgCount int = 2
param storageNames array = [
  'nikeanton42'
  'storage2'
  'storage3'
]




resource storage 'Microsoft.Storage/storageAccounts@2022-05-01' existing = {
  name: 'nikeanton42'
}


param containerName string = 'container1'


// Create container 
resource containers 'Microsoft.Storage/storageAccounts@2022-05-01' = [for i in range(0, length(containerName)): {
  name: '${i}storage${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}]
