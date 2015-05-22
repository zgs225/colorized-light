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

  describe 'Signal', ->
    beforeEach ->
      @signal = new Signal

    it 'should not be nil', ->
      expect(@signal).not.toBe undefined

    it 'should have an instance variable to store request', ->
      expect(typeof @signal.request).toBe 'string'

   describe 'LightSignal', ->
     beforeEach ->
       @lightSignal = new LightSignal '#000000', 1

     it 'should not be nil', ->
       expect(@lightSignal).toBeDefined()

     it 'request should be correct', ->
       expect(@lightSignal.request).toBe '\\x48\\x59\\x3C\\x07\\x11\\x01\\x00\\x00\\x00\\x00\\x00\\x00\\x10'

  describe 'Emitter', ->
    beforeEach ->
      @emitter = new Emitter

    it 'should have a list of signals to be sent', ->
      expect(angular.isArray(@emitter.signals)).toBe true

    it 'should have a method to register signal into emitter', ->
      @emitter.register new Signal
      expect(@emitter.signals.length).toEqual 1

    it 'should have a method to emit on signal', ->
      expect(@emitter.emitOne).toBeDefined()

    it 'should have a method to emit all signals', ->
      expect(@emitter.emit).toBeDefined()

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

    it 'should recognize if a color included in', ->
      expect(@palette.includes '#000000').toBe true
      expect(@palette.includes '#123456').toBe false

  describe 'Lamplet', ->
    beforeEach ->
      @lamplet = new Lamplet '#e30d20', 1

    it '__class function should return color-1', ->
      expect(@lamplet.__class()).toBe 'color-1'

    it 'should has a variable instance of Emitter', ->
      expect(typeof @lamplet.emitter).toBe 'object'

    it 'should has a variable as position of light', ->
      expect(@lamplet.position).toBeDefined()

    it 'the color of light should synchonized with car', ->
      expect(@lamplet.sync).toBe true

    it 'should has a method to change color', ->
      @lamplet.setColor '#000000', false
      expect(@lamplet.sync).toBe false
      expect(@lamplet.color).toBe '#000000'

    it 'should not change color when the color does not included in palette', ->
      @lamplet.setColor '#123456', false
      expect(@lamplet.color).toBe '#e30d20'

    it 'should has a method to generate light signal', ->
      expect(@lamplet.lightSignal).toBeDefined()

  describe 'List of Lamplets', ->
    beforeEach ->
      @lamplet = scope.lamplets[0]

    it 'should have 12 lamplets when initialize', ->
      expect(scope.lamplets.length).toBe 12

    it 'element of lamplets should be typeof Lamplet', ->
      expect(typeof @lamplet).toBe 'object'

    it 'first element should be light on', ->
      expect(@lamplet.lighting).toBe true

    it 'first element\'s color should be #e5147f', ->
      expect(@lamplet.color).toBe '#e2147f'

    it 'the position of first element of lamplets should equal 1', ->
      expect(@lamplet.position).toEqual 1

    it 'the position of last element of lamplets should equal 12', ->
      expect(scope.lamplets[scope.lamplets.length - 1].position).toEqual 12

    describe 'showPalette', ->
      it 'all lamplet\'s pallete should be hide', ->
        for lamplet in scope.lamplets
          expect(lamplet.palette.visible).toBe false

      it 'only one palette should be shown at same time', ->
        scope.lamplets[1].palette.show()
        scope.showPalette scope.lamplets[0]
        expect(scope.lamplets[1].palette.visible).toBe false
        expect(scope.lamplets[0].palette.visible).toBe true
