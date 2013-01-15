///<reference path="def/jquery.d.ts"/>
///<reference path="def/angular.d.ts"/>
///<reference path="def/underscore.d.ts"/>

// Require stuff (modules.js must be first! to initialize modules)
///<reference path="modules.ts"/>
///<reference path="controls/Admin.ts"/>
///<reference path="controls/Book.ts"/>
// require controllers here

console.log("Register: App")

var app = angular.module('app', ['controllers'], function ($routeProvider: ng.IRouteProviderProvider, $locationProvider: ng.ILocationProvider) {
  $locationProvider.html5Mode(true)
  $routeProvider.when('/404', {templateUrl: '/partials/404.html'})
  $routeProvider.when('/admin', {templateUrl: '/partials/admin.html', controller: "AdminCtrl"})
  $routeProvider.when('/admin/books/:id', {templateUrl: '/partials/book.html', controller: "BookCtrl"})
  $routeProvider.otherwise({redirectTo: '/admin'})
})

// ng-app wasn't always working. Make sure you don't have both!
angular.bootstrap($(document), ['app'])
