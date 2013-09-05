///<reference path="../def/angular.d.ts"/>
///<reference path="../types.ts"/>

function MigrationsCtrl($scope:any, $http: ng.IHttpService, $location:ng.ILocationService) {
  // zeros out the popularity of all books
  $scope.popularity = function() {
    $http.post("/books/migrations/popularity", {})
  }
}
