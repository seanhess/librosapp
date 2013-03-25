///<reference path="../def/angular.d.ts"/>
///<reference path="../def/underscore.d.ts"/>
///<reference path="../types.ts"/>

///<reference path="../services/Files.ts"/>

interface IHTMLFile {
  lastModifiedDate: Date;
  name: string;
  type: string; // mime type
  size: number; // bytes
}

interface BookParams extends ng.IRouteParamsService {
  bookId: string;
}

app.controller('BookCtrl', function($scope, Books:IBookService, Files:IFileService, $routeParams: BookParams, $location:ng.ILocationService, $http:ng.IHttpService) {
  var bookId = $scope.bookId = $routeParams.bookId

  $scope.book = Books.get({bookId:bookId})
  $scope.fileStatus = {}

  $http.get("/genres/").success(function(genres) {
    $scope.genres = genres
  })

  function calculateNumFiles() {
    $scope.book.audioFiles = Files.audioFiles($scope.book.files).length
    $scope.book.textFiles = Files.textFiles($scope.book.files).length
  }

  function back() {
    $location.path("/admin")
  }

  function bookValid(book:IBook) {
    if (!book) return false
    if (!book.files) return false
    var validFiles = book.files.filter(fileValid)
    if (validFiles.length < book.files.length) return false
    return true
  }

  function fileValid(file:IFile) {
    if (!file.url) return false
    if (!file.fileId) return false
    if (!file.name) return false
    if (!file.ext) return false
    return true
  }

  $scope.isBookValid = function() {
    return bookValid($scope.book)
  }

  $scope.toggleEditNewGenre = function() {
    $scope.editingNewGenre = !$scope.editingNewGenre
  }

  $scope.save = function(book) {
    Books.update($scope.book).then(back)
  }

  $scope.remove = function() {
    Books.remove({bookId: bookId}, back)
 }

  $scope.removeFile = function(file:IFile) {
    $scope.book.files = _.without($scope.book.files, file)
    calculateNumFiles()
  }

  $scope.isEditing = function(file) {
    return $scope.editing && $scope.editing.fileId == file.fileId
  }

  $scope.editFile = function(file:IFile) {
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

  $scope.onDrop = function(files:IHTMLFile[]) {
    files.forEach(addFile)
  }

  $scope.onDropCoverImage = function(files:IHTMLFile[]) {
    Files.upload(files[0])
    .then(function(file:IFile) {
      $scope.book.imageUrl = file.url
    })
  }

  $scope.clearImage = function() {
    delete $scope.book.imageUrl
  }

  $scope.isLoading = function(file:IFile) {
    return (file.fileId === undefined || file.fileId === null)
  }

  $scope.isFileUploadActive = function(file:IFile) {
    var op = $scope.fileStatus[file.name]
    if (!op) return false
    return op.active
  }

  function filesOfType(files:IFile[], ext:string):IFile[] {
    return files.filter(function(file:IFile) {
        return (file.ext == ext)
    })
  }

  function toPendingFile(htmlFile:IHTMLFile):IFile {
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

  function addFile(file:IHTMLFile) {

    var pendingFile = toPendingFile(file)
    $scope.book.files.push(pendingFile)

    var op = Files.queueUpload(file, function(file:IFile) {
       _.extend(pendingFile, file)
       delete $scope.fileStatus[file.name]
       calculateNumFiles()
    })

    $scope.fileStatus[pendingFile.name] = op
  }
})

