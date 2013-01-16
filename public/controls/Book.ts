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
  console.log("CHECK", $routeParams)

  $scope.book = {}

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

  $http.get("/books/" + $scope.bookId).success(function(book) {
    $scope.book = book
  })
})

