///<reference path="../def/angular.d.ts"/>

interface AdminScope extends ng.IScope {
  message: string;
  books: any[];
  genres: any[];
  createBook();
  createGenre();
  newGenre:string;
}

angular.module('controllers')
.controller('AdminCtrl', function($scope: AdminScope, $http: ng.IHttpService, $location:ng.ILocationService) {
  $scope.message = "hello3"
  load()

  function load() {
    $http.get('/books').success(function(books) {
      $scope.books = books
    })

    $http.get('/genres').success(function(genres) {
      $scope.genres = genres
    })
  }

  $scope.createBook = function() {
    $http.post("/books/", {}).success(function(book) {
      $location.path("/admin/books/" + book.bookId)
    })
  }

  $scope.createGenre = function() {
    // expects a json encoded string of genres?
    $http.post("/genres/", JSON.stringify($scope.newGenre)).success(load)
  }
})
