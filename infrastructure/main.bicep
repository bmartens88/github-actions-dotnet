param location string = 'westeurope'
@allowed(['dev', 'prod'])
param environment string

targetScope = 'resourceGroup'

module app './appservice.bicep' = {
  name: 'appservice'
  params: {
    appName: 'dometrain-github-actions'
    environment: environment
    location: location
  }
}
