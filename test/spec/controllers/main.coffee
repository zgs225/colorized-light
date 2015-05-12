'use strict'

describe 'Controller: MainCtrl', ->

  # load the controller's module
  beforeEach module 'colorizedLightApp'

  MainCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    MainCtrl = $controller 'MainCtrl', {
      $scope: scope
    }

  describe 'List of Lamplets', ->
    it 'should have 12 lamplets when initialize', ->
      expect(scope.lamplets.length).toBe 12

    it 'element of lamplets should be typeof Lamplet', ->
      expect(typeof scope.lamplets[0]).toBe 'object'

    it 'first element should be light on', ->
      expect(scope.lamplets[0].lighting).toBe true

    it 'first element\'s color should be #e5147f', ->
      expect(scope.lamplets[0].color).toBe '#e5147f'
