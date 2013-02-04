///<reference path="def/jquery.d.ts"/>
///<reference path="def/angular.d.ts"/>
///<reference path="def/underscore.d.ts"/>

// Require stuff (modules.js must be first! to initialize modules)
///<reference path="modules.ts"/>
///<reference path="controls/Admin.ts"/>
///<reference path="controls/Book.ts"/>
///<reference path="controls/Genre.ts"/>
///<reference path="controls/Author.ts"/>

///<reference path="directives/dragupload.ts"/>
///<reference path="directives/blur.ts"/>

// require controllers here

console.log("Register: App")


// Simple Stuff

//angular.module('services')
//.factory('Books', function($resource:ng.resource.IResourceService) {

//})

var app = angular.module('app', ['controllers'], function ($routeProvider: ng.IRouteProviderProvider, $locationProvider: ng.ILocationProvider) {
  $locationProvider.html5Mode(true)
  $routeProvider.when('/admin/404', {templateUrl: '/partials/404.html'})
  $routeProvider.when('/admin', {templateUrl: '/partials/admin.html', controller: "AdminCtrl"})
  $routeProvider.when('/admin/books/:bookId', {templateUrl: '/partials/book.html', controller: "BookCtrl"})
  $routeProvider.when('/admin/genres/:name/books', {templateUrl: '/partials/category.html', controller: "GenreCtrl"})
  $routeProvider.when('/admin/authors/:name/books', {templateUrl: '/partials/category.html', controller: "AuthorCtrl"})
  $routeProvider.otherwise({redirectTo: '/admin'})
})

// ng-app wasn't always working. Make sure you don't have both!
angular.bootstrap($(document), ['app'])
