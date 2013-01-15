///<reference path="../def/angular.d.ts"/>

angular.module('filters')

.filter("position", function(Board:IBoard) {
  return function(object:IPoint) {
    return {left: object.x * Board.UNIT + "px", top: object.y * Board.UNIT + "px"}
  }
})
