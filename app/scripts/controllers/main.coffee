'use strict'

class Lamplet
  constructor: (@color) ->
    @lighting = true

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
        '#e5147f', '#8959a1', '#89aad9',
        '#1ba1e9', '#1ba1e9', '#8959a1',
        '#e5147f', '#89abda', '#1ba1e9',
        '#1ba1e9', '#e5147f', '#89abda'
      ] .map (color) ->
        new Lamplet color
    )()
