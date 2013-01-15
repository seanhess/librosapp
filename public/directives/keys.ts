///<reference path="../def/angular.d.ts"/>
///<reference path="../def/jquery.d.ts"/>

angular.module('directives')
.directive('keypress', function($parse:ng.IParseService) {
  return function(scope:ng.IScope, element:JQuery, attrs) {
    // NOTE: removed isPressed check, which before disabled holding down the arrow keys to move
    // element is a jquery element

    // focus the div. without the first line it doesn't get keyboard events. 
    // without the second you have to click on it
    element.attr('tabindex', 0)
    element.focus()

    var onPress = $parse(attrs.keypress)
    //var isPressed = false

    element.keydown(function(e) {
        //if (isPressed) return
        //isPressed = true
        scope.$apply(function() {
          onPress(scope, {e:e})
        })
    });				

    //element.keyup(function(e) {
      //isPressed = false
    //})
  }
})

.directive('focus', function() {
  return function(scope:ng.IScope, element:JQuery, attrs) {
    scope.$watch(attrs.focus, function(value) {
      if (value) element.focus()
    }) 
  }
})

.directive('onEnter', function($parse:ng.IParseService) {
  return function(scope:ng.IScope, element:JQuery, attrs) {
    var onEnter = $parse(attrs.onEnter)
    element.bind("keydown", function(e) {
      if (e.keyCode == 13) {
        onEnter(scope)
      }
    })
  }
})
