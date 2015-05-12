'use strict'

###*
 # @ngdoc function
 # @name colorizedLightApp.controller:AboutCtrl
 # @description
 # # AboutCtrl
 # Controller of the colorizedLightApp
###
angular.module('colorizedLightApp')
  .controller 'AboutCtrl', ($scope) ->
    $scope.awesomeThings = [
      'HTML5 Boilerplate'
      'AngularJS'
      'Karma'
    ]
