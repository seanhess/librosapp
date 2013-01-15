///<reference path="../def/angular.d.ts"/>

interface AdminScope extends ng.IScope {
  message: string;
  books: any[];
}

angular.module('controllers')
.controller('AdminCtrl', function($scope: AdminScope) {
  $scope.message = "hello3"
  $scope.books = [{bookId: "one", title:"one"}]
})
