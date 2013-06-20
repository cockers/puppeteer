define [
  'modules/discovery/controllers/show-controller'
  'app.framework'
  'communication-bus'
], (ShowController, Framework, Bus) ->

  class DiscoveryModule extends Framework.Module

    initialize: (region) ->
      new ShowController region: region

  return DiscoveryModule