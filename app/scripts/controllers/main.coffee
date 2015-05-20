'use strict'

###*
 # @ngdoc class
 # @name Palette
 # @description
 # Abstract of palette that can change lamplet light color
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

  emitOne: (signal) ->
    jQuery.ajax
      url: "http://#{ @host }/#{ signal.request }"
      dataType: 'json'
      timeout: ->
        alert "Can't connected to #{ host }, please check your connection"
      success: (message) ->
        console.log 'Emitting signal success.' if message.result == 'success'

  emit: ->
    while (signal = @signals.shift())
      @emitOne(signal)

  register: (signal) ->
    @signals.push signal

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
    # 和小车同步
    @synchonized()

  synchonized: ->
    return true if @sync
    # TODO 和服务器同步
    @sync = true

  setColor: (color, sync = true) ->
    if @palette.includes color
      @color = color
      @sync  = false
    @synchonized() if sync

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

    $scope.showPalette = (currentLamplet, event) ->
      $scope.currentLamplet = currentLamplet
      for lamplet in $scope.lamplets
        lamplet.palette.hide()
      $scope.currentLamplet.palette.show()
      # Prevent event popup
      event.stopPropagation() if event # fix unit test

    $scope.hidePalette = ->
      $scope.currentLamplet.palette.hide() if $scope.currentLamplet
