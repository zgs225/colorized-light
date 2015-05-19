'use strict'

# @desc Abstract of palette that can change lamplet light color
class Palette
  constructor: ->
    @visible = false
    @colors  = [
      '#e30d20', '#e86aae', '#f19725', '#fdee35',
      '#e30f53', '#885a9f', '#5f549e', '#90c132',
      '#e2147f', '#179c96', '#1ba2e6', '#2daa40',
      '#ab5fa0', '#8aacd8', '#ffffff', '#000000'
    ]

  discern: (color)->
    index = @colors.indexOf(color.toLowerCase()) || 0
    "color-#{ index + 1 }"

  show: ->
    @visible = true

  hide: ->
    @visible = false

# @description abstract of lamplet
# that control the lamplet's behavior on page
class Lamplet
  constructor: (@color) ->
    @lighting = true
    @palette  = new Palette

  # Generate class name method
  __class: ->
    @palette.discern(@color)

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
      ] .map (color) ->
        new Lamplet color
    )()

    $scope.showPalette = (currentLamplet) ->
      for lamplet in $scope.lamplets
        lamplet.palette.hide()
      currentLamplet.palette.show()
