///<reference path="../def/angular.d.ts"/>
///<reference path="../def/jquery.d.ts"/>

angular.module('directives')
.directive('ngBlur', function() {
  return function(scope, elem, attrs ) {
    elem.bind('blur', function() {
      scope.$apply(attrs.ngBlur);
    });
  };
});
