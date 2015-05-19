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

  describe 'Palette', ->
    beforeEach ->
      @palette = new Palette

    it 'should be an instance', ->
      expect(@palette).not.toBe undefined

    it 'should have a method to discern color', ->
      expect(@palette.discern('#e30d20')).toBe 'color-1'

    it 'should be visible while invoke method show', ->
      @palette.show()
      expect(@palette.visible).toBe true

    it 'should not be visible while invoke method hide', ->
      @palette.show()
      @palette.hide()
      expect(@palette.visible).toBe false

  describe 'Lamplet', ->
    beforeEach ->
      @lamplet = new Lamplet '#e30d20'

    it '__class function should return color-1', ->
      expect(@lamplet.__class()).toBe 'color-1'

  describe 'List of Lamplets', ->
    it 'should have 12 lamplets when initialize', ->
      expect(scope.lamplets.length).toBe 12

    it 'element of lamplets should be typeof Lamplet', ->
      expect(typeof scope.lamplets[0]).toBe 'object'

    it 'first element should be light on', ->
      expect(scope.lamplets[0].lighting).toBe true

    it 'first element\'s color should be #e5147f', ->
      expect(scope.lamplets[0].color).toBe '#e2147f'

    describe 'showPalette', ->
      it 'all lamplet\'s pallete should be hide', ->
        for lamplet in scope.lamplets
          expect(lamplet.palette.visible).toBe false

      it 'only one palette should be shown at same time', ->
        scope.lamplets[1].palette.show()
        scope.showPalette scope.lamplets[0]
        expect(scope.lamplets[1].palette.visible).toBe false
        expect(scope.lamplets[0].palette.visible).toBe true
