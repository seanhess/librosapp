///<reference path="../def/angular.d.ts"/>
///<reference path="../services/Shared.ts"/>
///<reference path="../services/FB.ts"/>
///<reference path="../services/Id.ts"/>


interface AdminScope extends ng.IScope {
  message: string;
}

angular.module('controllers')
.controller('AdminCtrl', function($scope: AdminScope) {
  $scope.message = "hello3"
})
