///<reference path="../def/angular.d.ts"/>

module book {

  export interface Params extends ng.IRouteParamsService {
    bookId: string;
  }

  export interface IBook {
    bookId:string;
    title:string;
  }

  export interface IFile {
    bookId: string;
    fileId: string;
    name:string;
    ext:string;
    url:string;
  }

  export interface IHTMLFile {
    lastModifiedDate: Date;
    name: string;
    type: string; // mime type
    size: number; // bytes
  }
}

angular.module('controllers')
.controller('BookCtrl', function($scope, $routeParams: book.Params, $location:ng.ILocationService, $http:ng.IHttpService) {
  $scope.bookId = $routeParams.bookId

  $scope.book = null
  $scope.files = []

  loadBook()
  loadFiles()

  function loadBook() {
    $http.get("/books/" + $scope.bookId).success(function(book) {
      $scope.book = book
    })
  }

  function loadFiles() {
    $http.get("/books/" + $scope.bookId + "/files").success(function(files) {
      $scope.files = files
    })
  }

  $scope.save = function(book) {
    $http.put("/books/" + $scope.bookId, $scope.book).
      success(function() {
        $location.path("/admin")
      })
  }

  $scope.remove = function() {
    $http.delete('/books/' + $scope.book.bookId).success(function() {
      $location.path("/admin")
    })
  }

  $scope.removeFile = function(file:book.IFile) {
    $scope.files = _.without($scope.files, file)
    $http.delete('/files/' + file.fileId).success(function() {
      //loadFiles()
    })
  }

  $scope.isEditing = function(file) {
    return $scope.editing && $scope.editing.fileId == file.fileId
  }

  $scope.editFile = function(file:book.IFile) {
    $scope.editing = _.clone(file)
  }

  $scope.cancelEdit = function() {
    delete $scope.editing
  }

  $scope.updateFile = function(file) {
    file.name = $scope.editing.name
    $scope.cancelEdit()
    $http.put('/files/' + file.fileId, file).success(function() {
      //loadFiles()
    })
  }

  $scope.onDrop = function(files:book.IHTMLFile[]) {

    console.log("ON DROP", files)
    // files.forEach($scope.addFile)
    // fatzo
    //addFile(files[0])
    files.forEach(addFile)
  }

  $scope.isLoading = function(file:book.IFile) {
    return !file.fileId
  }

  function toPendingFile(htmlFile:book.IHTMLFile):book.IFile {
    var ext = htmlFile.name.match(/\.(\w+)$/)[1]
    var name = htmlFile.name.replace("." + ext, "")

    // you can tell it's pending because it doesn't have url, fileId, bookId
    return {
      name:name,
      ext:ext,
      url:undefined,
      fileId:undefined,
      bookId:undefined,
    }
  }

  function addFile(file:book.IHTMLFile) {
    var pendingFile = toPendingFile(file)
    $scope.files.push(pendingFile)

    var formData = new FormData()
    formData.append('files', file)

    $http({
      method: 'POST',
      url: '/books/' + $scope.book.bookId + "/files",
      data: formData,
      // no idea why you need both of these, but you do
      transformRequest: angular.identity,
      headers: {'Content-Type': undefined},
    })
    .success(function(files:book.IFile[]) {
      var file = files[0]
       _.extend(pendingFile, file)
    })
  }
})

