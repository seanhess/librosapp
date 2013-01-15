console.log("INITIALIZING MODULES");
angular.module('services', []);
angular.module('directives', []);
angular.module('filters', []);
angular.module('controllers', [
    'services', 
    'filters', 
    'directives'
]);
angular.module('controllers').controller('AdminCtrl', function ($scope) {
    $scope.message = "hello3";
});
console.log("Register: App3");
var app = angular.module('app', [
    'controllers'
], function ($routeProvider, $locationProvider) {
    $locationProvider.html5Mode(true);
    $routeProvider.when('/404', {
        templateUrl: 'partials/404.html'
    });
    $routeProvider.when('/admin', {
        templateUrl: 'partials/admin.html',
        controller: "AdminCtrl"
    });
    $routeProvider.otherwise({
        redirectTo: '/404'
    });
});
angular.bootstrap($(document), [
    'app'
]);
