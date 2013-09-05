///<reference path="../types.ts"/>
///<reference path="../def/angular.d.ts"/>

interface Service extends ng.resource.IResourceClass {
  books: ng.resource.IResourceClass;
}

function Genres($http: ng.IHttpService, $resource:ng.resource.IResourceService):Service {
    var Genres:Service = <any> $resource("/genres/:name")
    Genres.books = $resource("/genres/:name/books")
    return Genres
}

