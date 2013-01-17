///<reference path="../def/angular.d.ts"/>

module book {

  export interface Params extends ng.IRouteParamsService {
    bookId: string;
  }

  export interface IBook {
    bookId:string;
    title:string;
  }

}

angular.module('controllers')
.controller('BookCtrl', function($scope, $routeParams: book.Params, $location:ng.ILocationService, $http:ng.IHttpService) {
  $scope.bookId = $routeParams.bookId

  $scope.book = {}
  $scope.files = []
  $scope.create = ($scope.bookId === "create")

  loadBook()

  function loadBook() {
    $http.get("/books/" + $scope.bookId).success(function(book) {
      $scope.book = book
    })
  }

  function loadFiles() {
    $http.get("/books/" + $scope.bookId + "/files").success(function(files) {
      $scope.files = files
    })
  }

  $scope.save = function(book) {
    $http.post("/books/", $scope.book).
      success(function() {
        console.log("POSTED")
        $location.path("/admin")
      })
  }

  $scope.remove = function() {
    $http.delete('/books/' + $scope.book.bookId).success(function() {
      $location.path("/admin")
    })
  }

  $scope.onDrop = function(files, formData) {
    console.log("ON DROP FILES", files, formData)
    $http({
      method: 'POST',
      url: '/books/' + $scope.book.bookId + "/files",
      data: formData,
      transformRequest: angular.identity,
      headers: {'Content-Type': undefined},
    })
    .success(function() {
      loadFiles()
    })
  }

})

