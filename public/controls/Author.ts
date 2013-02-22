
///<reference path="../def/angular.d.ts"/>

app.controller('AuthorCtrl', function($scope: any, $http: ng.IHttpService, $location:ng.ILocationService, $routeParams:IAuthor) {
  var name = $routeParams.name
  $scope.categoryName = name
  $http.get("/authors/"+name+"/books")
  .success((books:IBook[]) => {
    $scope.books = books
  })
})

