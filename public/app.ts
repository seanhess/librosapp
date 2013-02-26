///<reference path="def/jquery.d.ts"/>
///<reference path="def/angular.d.ts"/>
///<reference path="def/underscore.d.ts"/>

// MUST BE FIRST
///<reference path="router.ts"/>

///<reference path="controls/Admin.ts"/>
///<reference path="controls/Book.ts"/>
///<reference path="controls/Genre.ts"/>
///<reference path="controls/Author.ts"/>

///<reference path="services/Files.ts"/>
///<reference path="services/Books.ts"/>

///<reference path="directives/dragupload.ts"/>
///<reference path="directives/blur.ts"/>

///<reference path="filters/toProductId.ts"/>

angular.bootstrap($(document), ['app'])
