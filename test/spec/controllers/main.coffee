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

  it 'should has a car controller in scope', ->
    expect(scope.carController).toBeDefined()

  it 'variable countDown in scope should be false', ->
    expect(scope.countDown).toBe false

  it 'variable startButton in scope should be true', ->
    expect(scope.startButton).toBe true

  describe 'Game start', ->
    it 'should has a method to start game', ->
      expect(scope.gameStart).toBeDefined()

    it 'should has a method to listen window orientation', ->
      expect(scope.listenDeviceOrientation).toBeDefined()

    it 'should has a method to remove window orientation listener', ->
      expect(scope.removeListenDeviceOrientation).toBeDefined()

  describe 'CarController', ->
    beforeEach ->
      @carController = new CarController

    it 'CarController shoud be defined', ->
      expect(CarController).toBeDefined()

    it 'should has an emitter to emit signal', ->
      expect(@carController.emitter).toBeDefined()

    it 'should has a variable to store go signal', ->
      expect(@carController.goSignal).toBeDefined()
      expect(@carController.goSignal.behaviour).toBe 'd'

    it 'should has a variable to store stop signal', ->
      expect(@carController.stopSignal).toBeDefined()
      expect(@carController.stopSignal.behaviour).toBe 'h'

    it 'should has a variable to store left signal', ->
      expect(@carController.leftSignal).toBeDefined()
      expect(@carController.leftSignal.behaviour).toBe 'l'

    it 'should has a variable to store right signal', ->
      expect(@carController.rightSignal).toBeDefined()
      expect(@carController.rightSignal.behaviour).toBe 'r'

    it 'should has a method to controll the car go ahead', ->
      expect(@carController.go).toBeDefined()

    it 'should has a method to control the car to stop', ->
      expect(@carController.stop).toBeDefined()

    it 'should has a method to control the car turn left', ->
      expect(@carController.left).toBeDefined()

    it 'should has a method to control the car turn right', ->
      expect(@carController.right).toBeDefined()

    it 'should has a method to control car to turn left or right', ->
      expect(@carController.turn).toBeDefined()

    it 'the request of turn left signal should be same as original after invoke left method', ->
      originRequest = @carController.leftSignal.request
      @carController.left()
      expect(@carController.leftSignal.request).toEqual originRequest

    it 'the request of turn left signal should be same as original after invoke right method', ->
      originRequest = @carController.rightSignal.request
      @carController.right()
      expect(@carController.rightSignal.request).toEqual originRequest

  describe 'Signal', ->
    beforeEach ->
      @signal = new Signal

    it 'should not be nil', ->
      expect(@signal).not.toBe undefined

    it 'should have an instance variable to store request', ->
      expect(typeof @signal.request).toBe 'string'

   describe 'LightSignal', ->
     beforeEach ->
       @lightSignal = new LightSignal(scope.lamplets.slice(0, 4))

     it 'should not be nil', ->
       expect(@lightSignal).toBeDefined()

     it 'request should be correct', ->
       expect(@lightSignal.request).toBe 'ping.sh?\\x48\\x59\\x3C\\x19\\x11\\x01\\xe2\\x00\\x7f\\x00\\x14\\x00\\x88\\x00\\x9f\\x00\\x5a\\x00\\x8a\\x00\\xd8\\x00\\xac\\x00\\x1b\\x00\\xe6\\x00\\xa2\\x00\\x10'

   describe 'CarSignal', ->
     beforeEach ->

     it 'should be defined', ->
       expect(CarSignal).toBeDefined()

     it 'request should be correct when behaviour equals d', ->
       @carSignal = new CarSignal 'd'
       expect(@carSignal.request).toBe 'che2.sh?\\x00\\x64\\x10'

     it 'request should be correct when behaviour equals h', ->
       @carSignal = new CarSignal 'h'
       expect(@carSignal.request).toBe 'che2.sh?\\x00\\x68\\x10'

     it 'request should be correct when behaviour equals l', ->
       @carSignal = new CarSignal 'l'
       expect(@carSignal.request).toBe 'che2.sh?\\x01\\x6c\\x0{{level}}\\x10'

     it 'request should be correct when behaviour equals r', ->
       @carSignal = new CarSignal 'r'
       expect(@carSignal.request).toBe 'che2.sh?\\x01\\x72\\x0{{level}}\\x10'

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
      expect(@lamplet.sync).toBe undefined

    it 'should has a method to change color', ->
      @lamplet.setColor '#000000', false
      expect(@lamplet.sync).toBe false
      expect(@lamplet.color).toBe '#000000'

    it 'chained to other lamplets', ->
      expect(@lamplet.lampletsOnSameScreen).toBeDefined()

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

    it 'first element of lamplets should on screen 1', ->
      expect(@lamplet.onScreen).toBe 1

    it 'the last element of lamplets should on screen 3', ->
      expect(scope.lamplets[scope.lamplets.length - 1].onScreen).toBe 3

    it 'the lamplets on the same screen of first lamplet should be 4', ->
      expect(@lamplet.lampletsOnSameScreen.length).toBe 4

    describe 'showPalette', ->
      it 'all lamplet\'s pallete should be hide', ->
        for lamplet in scope.lamplets
          expect(lamplet.palette.visible).toBe false

      it 'only one palette should be shown at same time', ->
        scope.lamplets[1].palette.show()
        scope.showPalette scope.lamplets[0]
        expect(scope.lamplets[1].palette.visible).toBe false
        expect(scope.lamplets[0].palette.visible).toBe true
