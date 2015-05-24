'use strict'

###*
 # @ngdoc class
 # @name Palette
 # @description
 # Abstract of palette that can change the color of light of lamplet
###
class Palette
  constructor: ->
    @visible = false
    @colors  = [
      '#e30d20', '#e86aae', '#f19725', '#fdee35',
      '#e30f53', '#885a9f', '#5f549e', '#90c132',
      '#e2147f', '#179c96', '#1ba2e6', '#2daa40',
      '#ab5fa0', '#8aacd8', '#ffffff', '#000000'
    ]

  discern: (color) ->
    index = @colors.indexOf(color.toLowerCase())
    index = 0 if index == -1
    "color-#{ index + 1 }"

  show: ->
    @visible = true

  hide: ->
    @visible = false

  includes: (color) ->
    color in @colors

###*
 # @ngdoc class
 # @name Signal
 # @description
 # Command container
###
class Signal
  constructor: (request) ->
    @request = request || ""

  checkSum: ->
    '\\x10'

###*
 # @ngdoc class
 # @name LightSignal
 # @description
 # Command container of light
###
class LightSignal extends Signal
  constructor: (@lamplets) ->
    @request =
      "#{ @requestFile() }?#{ @header() }#{ @requestLength() }#{ @command() }#{ @positionData() }#{ @colorDataForLamplets() }#{ @checkSum() }"

  requestFile: ->
    'ping.sh'

  header: ->
    '\\x48\\x59\\x3C'

  requestLength: ->
    '\\x19'

  command: ->
    '\\x11'

  positionData: ->
    zero = '00'
    hex  = @lamplets[0].onScreen.toString 16
    tmp  = zero.length - hex.length
    "\\x#{ zero.substr(0, tmp) }#{ hex }"

  colorDataForLamplets: ->
    result = ''
    for lamplet in @lamplets
      result += @colorData(lamplet.color)
    result

  colorData: (color) ->
    r = color.slice 1, 3
    g = color.slice 3, 5
    b = color.slice 5, 7
    "\\x#{ r }\\x00\\x#{ b }\\x00\\x#{ g }\\x00"

###*
 # @ngdoc class
 # @name CarSignal
 # @description
 # Command container of car
###
class CarSignal extends Signal
  ###*
   # @param behaviour 
   # 用来区别小车的行动
   # u 后退
   # d 前进
   # l 左转
   # r 右转
   # h 停止
  ###
  constructor: (@behaviour) ->
    super "#{ @requestFile() }?#{ @dataLength() }#{ @behaviourAsHex() }#{ @behaviourData() }#{ @checkSum() }"

  requestFile: ->
    'che2.sh'

  dataLength: ->
    switch @behaviour
      when 'd', 'h'
        '\\x00'
      when 'l', 'r'
        '\\x01'

  behaviourAsHex: ->
    "\\x#{ @behaviour.charCodeAt().toString 16 }"

  behaviourData: ->
    switch @behaviour
      when 'l', 'r'
        "\\x0{{level}}"
      else
        ''

###*
 # @ngdoc class
 # @name Emitter
 # @description
 # Transfer signals to car
###
class Emitter
  constructor: ->
    @signals = []
    @host    = '192.168.8.1'
    @path    = 'cgi-bin/dn'

  emitOne: (signal) ->
    return false if typeof jQuery == 'undefined'

    jQuery.ajax
      url: "http://#{ @host }/#{ @path }/#{ signal.request }"
      dataType: 'json'
      timeout: 500
      crossDomain: true
      async: false
      success: (message) ->
        console.log 'Emitting signal success.' if message.result == 'success'

  emit: ->
    while (signal = @signals.shift())
      @emitOne(signal)

  register: (signal) ->
    @signals.push signal

###*
 # @ngdoc class
 # @name CarController
 # @description
 # Model to control the car
###
class CarController
  constructor: ->
    @emitter    = new Emitter
    @goSignal   = new CarSignal 'd'
    @stopSignal = new CarSignal 'h'
    @leftSignal = new CarSignal 'l'

  go: ->
    @emitter.emitOne @goSignal

  stop: ->
    @emitter.emitOne @stopSignal

  left: (level = 1) ->
    level = 1 if level < 1
    level = 9 if level > 9
    @leftSignal.__originRequest = @leftSignal.request
    @leftSignal.request = @leftSignal.request.replace /{{level}}/, level
    @emitter.emitOne @leftSignal
    @leftSignal.request = @leftSignal.__originRequest

###*
 # @ngdoc class
 # @name Lamplet
 # @description
 # abstract of lamplet that control the lamplet's behavior on page
###
class Lamplet
  constructor: (@color, @position) ->
    # 是否发光
    @lighting = true
    @palette  = new Palette
    @emitter  = new Emitter
    @onScreen = @whichScreen()
    @lampletsOnSameScreen = []

  whichScreen: ->
    return 3 if @position >= 9
    return 2 if @position >= 5
    return 1

  synchonized: ->
    return true if @sync
    @emitter.emitOne @lightSignal()
    for lamplet in @lampletsOnSameScreen
      lamplet.sync = true

  setColor: (color, sync = true) ->
    if @palette.includes color
      @color = color
      @sync  = false
    @synchonized() if sync

  lightSignal: ->
    new LightSignal @lampletsOnSameScreen

  # Generate class name method
  __class: ->
    @palette.discern @color

###*
 # @ngdoc function
 # @name colorizedLightApp.controller:MainCtrl
 # @description
 # # MainCtrl
 # Controller of the colorizedLightApp
###
angular.module('colorizedLightApp')
  .controller 'MainCtrl', ($scope) ->
    # List of lamplets
    $scope.lamplets = (->
      [
        '#e2147f', '#885a9f', '#8aacd8',
        '#1ba2e6', '#1ba2e6', '#885a9f',
        '#e2147f', '#8aacd8', '#1ba2e6',
        '#1ba2e6', '#e2147f', '#8aacd8'
      ].map (color, index) ->
        new Lamplet color, index + 1
    )()

    # 给小灯分配屏幕关系
    for lamplet in $scope.lamplets
      for lamp in $scope.lamplets
        lamplet.lampletsOnSameScreen.push lamp if lamplet.onScreen == lamp.onScreen

    # 同步小车灯光
    for lamplet in $scope.lamplets
      lamplet.synchonized()

    $scope.showPalette = (currentLamplet, event) ->
      $scope.currentLamplet = currentLamplet
      for lamplet in $scope.lamplets
        lamplet.palette.hide()
      $scope.currentLamplet.palette.show()
      # Prevent event popup
      event.stopPropagation() if event # fix unit test

    $scope.hidePalette = ->
      $scope.currentLamplet.palette.hide() if $scope.currentLamplet

    $scope.carController = new CarController

    # 监听屏幕倾斜
    $scope.listenDeviceOrientation = ->
      window.addEventListener 'deviceorientation', (event) ->

    # 移除屏幕监听
    $scope.removeListenDeviceOrientation = ->
      window.removeEventListener 'deviceorientation'

    # 游戏开始
    $scope.gameStart = ->
      # Go
      # $scope.carController.go()

      # 添加监听器
      # $scope.listenDeviceOrientation()

      # 左转
      $scope.carController.left 2

      # Stop
      # $scope.carController.stop()
