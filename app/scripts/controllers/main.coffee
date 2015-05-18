'use strict'

# @description abstract of lamplet
# that control the lamplet's behavior on page
class Lamplet
  constructor: (@color) ->
    @lighting = true

  # Generate class name method
  __class: ->
    colors = [
      '#e30d20', '#e86aae', '#f19725', '#fdee35',
      '#e30f53', '#885a9f', '#5f549e', '#90c132',
      '#e2147f', '#179c96', '#1ba2e6', '#2daa40',
      '#ab5fa0', '#8aacd8', '#ffffff'
    ]
    index = colors.indexOf(@color.toLowerCase()) || 0
    "color-#{ index + 1 }"

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
