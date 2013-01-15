///<reference path="../def/angular.d.ts"/>

module book {

  export interface Params extends ng.IRouteParamsService {
    bookId: string;
  }

}

angular.module('controllers')
.controller('BookCtrl', function($scope, $routeParams: book.Params, $location:ng.ILocationService, $http:ng.IHttpService) {
  $scope.bookId = $routeParams.bookId

  $scope.save = function(book) {
    $http.post("/books/", $scope.book).
      success(function() {
        console.log("POSTED")
        $location.path("/admin")
      })
  }
})

