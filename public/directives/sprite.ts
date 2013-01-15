///<reference path="../def/angular.d.ts"/>

angular.module('directives')

// simple directive that updates the background-y given a direction
// shouldn't some of this be in the css instead? Should this have the knowledge
// of the background size?

.directive('spriteDirection', function(Board:IBoard) {
  return {
    restrict:'A',
    link:function(scope:ng.IScope, element:JQuery, attrs) {
      scope.$watch(attrs.spriteDirection, function(direction) {
        direction = direction || Board.DOWN

        if(direction == Board.UP)
          element.css('backgroundPositionY', '-100px');

        else if(direction == Board.RIGHT)
          element.css('backgroundPositionY', '-50px');

        else if(direction == Board.DOWN)
          element.css('backgroundPositionY', '-150px');

        else if(direction == Board.LEFT)
          element.css('backgroundPositionY', '0px');
      })
    }
  }
})

// animates through N background states, all at 50px (of course) :)
.directive('spriteAnimate', function() {
  return function(scope:ng.IScope, element:JQuery, attrs) {

  }
})

// Now, sprite-walking. I need to know when either x or y changes
.directive('spriteWalking', function(Board:IBoard) {
  return function(scope:ng.IScope, element:JQuery, attrs) {

    var ANIMATE_DURATION = 500
    var FRAME_DURATION = 70
    var TOTAL_FRAMES = Math.ceil(ANIMATE_DURATION / FRAME_DURATION)

    // animate up to a certain number of times
    // well, until css transition end, really
    // you need to know the duration, so you can set a timer

    var interval;
    var frame;

    function startWalking() {
      frame = 0
      stopWalking() // don't double animate!
      interval = setInterval(animateFrame, FRAME_DURATION)
      animateFrame()
    }

    function stopWalking() {
      frame = 0
      clearInterval(interval)
    }

    function animateFrame() {
      var sprite = frame++ % 3
      if(sprite == 0)      element.css('backgroundPositionX', '0');
      else if(sprite == 1) element.css('backgroundPositionX', '-50px');
      else if(sprite == 2) element.css('backgroundPositionX', '-100px');
      if (frame >= TOTAL_FRAMES) stopWalking()
    }

    attrs.$observe('spriteWalking', startWalking)
  }
})


// TODO more generic form you can use for missiles, or the explosion, etc
// just some way to kick off a Y-based animation when a property changes?
