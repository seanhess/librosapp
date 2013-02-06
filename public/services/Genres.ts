///<reference path="../types.ts"/>

import Angular = module('lib/angular')
var angular = Angular.main

export interface IService extends ng.resource.IResourceClass {
  books: ng.resource.IResourceClass;
}

angular.module('services')
.controller('Genres', function($http: ng.IHttpService, $resource:ng.resource.IResourceService) {
    var Genres:IService = <any> $resource("/genres/:name")
    Genres.books = $resource("/genres/:name/books")
    return Genres
})

