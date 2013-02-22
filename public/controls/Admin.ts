///<reference path="../def/angular.d.ts"/>

interface AdminScope extends ng.IScope {
  message: string;
  books: IBook[];
  genres: IGenre[];
  authors: IAuthor[];
  createBook();
  createGenre();
  newGenre:string;
}

app.controller('AdminCtrl', function($scope: AdminScope, $http: ng.IHttpService, $location:ng.ILocationService) {
  $scope.message = "hello3"
  load()

  function load() {
    $http.get('/books').success(function(books) {
      $scope.books = books
    })

    $http.get('/genres').success(function(genres) {
      $scope.genres = genres
    })

    $http.get('/authors').success(function(authors) {
      $scope.authors = authors
    })
  }

  $scope.createBook = function() {
    $http.post("/books/", {}).success(function(book) {
      $location.path("/admin/books/" + book.bookId)
    })
  }
})
