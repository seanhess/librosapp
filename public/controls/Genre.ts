///<reference path="../def/angular.d.ts"/>

app.controller('GenreCtrl', function($scope: any, $http: ng.IHttpService, $location:ng.ILocationService, $routeParams:IGenre) {
  var genre = $routeParams.name
  $scope.categoryName = genre
  $http.get("/genres/"+genre+"/books")
  .success((books:IBook[]) => {
    $scope.books = books
  })
})

