console.log("INITIALIZING MODULES");
angular.module('services', []);
angular.module('directives', []);
angular.module('filters', []);
angular.module('controllers', [
    'services', 
    'filters', 
    'directives'
]);
