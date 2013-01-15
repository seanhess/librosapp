console.log("INITIALIZING MODULES")
// Initialize Angular Modules
angular.module('services',[])
angular.module('directives',[])
angular.module('filters',[])
angular.module('controllers',['services', 'filters', 'directives'])
