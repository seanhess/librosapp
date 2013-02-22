///<reference path="../types.ts"/>

interface IFileService extends ng.resource.IResourceClass {
  upload(file:IHTMLFile):ng.IPromise;
  audioFiles(files:IFile[]):IFile[];
  textFiles(files:IFile[]):IFile[];
}

app.factory('Files', function($http: ng.IHttpService):IFileService {
    function not(f:Function) {
      return function(...args:any[]) {
        return !f.apply(null, args)
      }
    }

    function isAudio(file:IFile) {
      return file.ext == "mp3"
    }

    var Files:IFileService = <any> {}
    Files.upload = function(file:IHTMLFile) {
      // must be a file from the web browser
      var formData = new FormData()
      formData.append('file', file)
      return $http({
        method: 'POST',
        url: '/files',
        data: formData,
        // no idea why you need both of these, but you do
        transformRequest: angular.identity,
        headers: {'Content-Type': undefined},
      })
      .then((rs) => rs.data)
    }
    Files.audioFiles = function(files:IFile[]) {
      return files.filter(isAudio)
    }
    Files.textFiles = function(files:IFile[]) {
      return files.filter(not(isAudio))
    }
    return Files
})

