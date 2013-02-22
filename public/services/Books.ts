///<reference path="../types.ts"/>

interface IBookService extends ng.resource.IResourceClass {
  update(book:IBook):ng.IPromise;
}

app.factory('Books', function($http: ng.IHttpService, $resource: ng.resource.IResourceService):IBookService {
    var Books:IBookService = <any> $resource("/books/:bookId", {}, {})
    Books.update = function(book:IBook) {
      return $http
      .put('/books/'+book.bookId, book)
      .then((rs) => rs.data)
    }
    return Books
})

