///<reference path="../def/angular.d.ts"/>
///<reference path="../types.ts"/>

function GenreCtrl($scope: any, $http: ng.IHttpService, $location:ng.ILocationService, $routeParams:IGenre) {
  var genre = $routeParams.name
  $scope.categoryName = genre
  $http.get("/genres/"+genre+"/books")
  .success((books:IBook[]) => {
    $scope.books = books
  })
}

