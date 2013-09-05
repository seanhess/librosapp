///<reference path="../def/angular.d.ts"/>
///<reference path="../def/jquery.d.ts"/>

function ngBlur() {
  return function(scope, elem, attrs ) {
    elem.bind('blur', function() {
      scope.$apply(attrs.ngBlur);
    });
  };
};