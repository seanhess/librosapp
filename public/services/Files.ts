///<reference path="../types.ts"/>

interface IFileService extends ng.resource.IResourceClass {
  upload(file:IHTMLFile):ng.IPromise;
}

app.factory('Files', function($http: ng.IHttpService):IFileService {
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
    return Files
})

