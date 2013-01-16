///<reference path="../def/angular.d.ts"/>

interface AdminScope extends ng.IScope {
  message: string;
  books: any[];
}

angular.module('controllers')
.controller('AdminCtrl', function($scope: AdminScope, $http: ng.IHttpService) {
  $scope.message = "hello3"
  load()

  function load() {
    $http.get('/books').success(function(books) {
      console.log("BOOKS", books)
      $scope.books = books
    })
  }
})
