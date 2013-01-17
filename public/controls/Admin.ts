///<reference path="../def/angular.d.ts"/>

interface AdminScope extends ng.IScope {
  message: string;
  books: any[];
  createBook();
}

angular.module('controllers')
.controller('AdminCtrl', function($scope: AdminScope, $http: ng.IHttpService, $location:ng.ILocationService) {
  $scope.message = "hello3"
  load()

  function load() {
    $http.get('/books').success(function(books) {
      $scope.books = books
    })
  }

  $scope.createBook = function() {
    $http.post("/books/", {}).
      success(function(book) {
        $location.path("/admin/books/" + book.bookId)
      })
  }
})
