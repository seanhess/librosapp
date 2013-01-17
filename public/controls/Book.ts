///<reference path="../def/angular.d.ts"/>

module book {

  export interface Params extends ng.IRouteParamsService {
    bookId: string;
  }

  export interface IBook {
    bookId:string;
    title:string;
  }

  export interface IFile {
    bookId: string;
    fileId: string;
    name:string;
    ext:string;
    url:string;
  }

}

angular.module('controllers')
.controller('BookCtrl', function($scope, $routeParams: book.Params, $location:ng.ILocationService, $http:ng.IHttpService) {
  $scope.bookId = $routeParams.bookId

  $scope.book = null
  $scope.files = []

  loadBook()
  loadFiles()

  function loadBook() {
    $http.get("/books/" + $scope.bookId).success(function(book) {
      $scope.book = book
    })
  }

  function loadFiles() {
    $http.get("/books/" + $scope.bookId + "/files").success(function(files) {
      console.log(files)
      $scope.files = files
    })
  }

  $scope.save = function(book) {
    $http.put("/books/" + $scope.bookId, $scope.book).
      success(function() {
        $location.path("/admin")
      })
  }

  $scope.remove = function() {
    $http.delete('/books/' + $scope.book.bookId).success(function() {
      $location.path("/admin")
    })
  }

  $scope.removeFile = function(file:book.IFile) {
    $http.delete('/files/' + file.fileId).success(function() {
      loadFiles()
    })
  }

  $scope.onDrop = function(files, formData) {
    $http({
      method: 'POST',
      url: '/books/' + $scope.book.bookId + "/files",
      data: formData,
      // no idea why you need both of these, but you do
      transformRequest: angular.identity,
      headers: {'Content-Type': undefined},
    })
    .success(function() {
      loadFiles()
    })
  }
})

