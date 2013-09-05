///<reference path="def/jquery.d.ts"/>
///<reference path="def/angular.d.ts"/>
///<reference path="def/underscore.d.ts"/>

// MUST BE FIRST

///<reference path="controls/Admin.ts"/>
///<reference path="controls/Book.ts"/>
///<reference path="controls/Genre.ts"/>
///<reference path="controls/Author.ts"/>
///<reference path="controls/Migrations.ts"/>

///<reference path="services/Files.ts"/>
///<reference path="services/Books.ts"/>
///<reference path="services/Genres.ts"/>

///<reference path="directives/dragupload.ts"/>
///<reference path="directives/blur.ts"/>

///<reference path="filters/toProductId.ts"/>

console.log("Register: App")

angular.module('app', ['ngResource'])

.factory("Books", Books)
.factory("Genres", Genres)
.factory("Files", Files)

.directive("ngBlur", ngBlur)
.directive("dragUpload", dragUpload)
.directive("dragIgnore", dragIgnore)

.filter("toProductId", toProductId)

.config(function($routeProvider: ng.IRouteProvider, $locationProvider: ng.ILocationProvider) {
  console.log("INSIDE ROUTER")
  $locationProvider.html5Mode(true)
  $routeProvider.when('/admin/404', {templateUrl: '/partials/404.html'})
  $routeProvider.when('/admin', {templateUrl: '/partials/admin.html', controller: AdminCtrl})
  $routeProvider.when('/admin/books/:bookId', {templateUrl: '/partials/book.html', controller: BookCtrl})
  $routeProvider.when('/admin/genres/:name/books', {templateUrl: '/partials/category.html', controller: GenreCtrl})
  $routeProvider.when('/admin/authors/:name/books', {templateUrl: '/partials/category.html', controller: AuthorCtrl})
  $routeProvider.when('/admin/migrations', {templateUrl: '/partials/migrations.html', controller: MigrationsCtrl})
  $routeProvider.otherwise({redirectTo: '/admin'})
})

angular.bootstrap($(document), ['app'])
