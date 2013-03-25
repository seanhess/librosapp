///<reference path="../types.ts"/>

interface IFileCb {
  (file:IFile);
}

interface IFileService extends ng.resource.IResourceClass {
  upload(file:IHTMLFile):ng.IPromise;
  queueUpload(file:IHTMLFile, cb:IFileCb):FileServiceUploadOperation;
  audioFiles(files:IFile[]):IFile[];
  textFiles(files:IFile[]):IFile[];
}

interface FileServiceUploadOperation {
  file:IHTMLFile;
  active:bool;
  cb(file:IFile);
}

// TODO: turn this into a queue

app.factory('Files', function($http: ng.IHttpService):IFileService {
    function not(f:Function) {
      return function(...args:any[]) {
        return !f.apply(null, args)
      }
    }

    function isAudio(file:IFile) {
      return file.ext == "mp3"
    }

    var queue:FileServiceUploadOperation[] = []
    var currentOp:FileServiceUploadOperation;

    function nextUpload() {
      currentOp = queue.pop()
      currentOp.active = true
      Files.upload(currentOp.file)
      .then((file:IFile) => currentOp.cb(file))
      .then(function() {
        currentOp = null
        if (queue.length) nextUpload()
      })
    }

    // this can return a promise object thing
    // should be thenable, for when it finishes
    // but also have a progress
    var Files:IFileService = <any> {}
    Files.queueUpload = function(file:IHTMLFile, cb:IFileCb) {
      var op:FileServiceUploadOperation = {file:file, cb:cb, active:false}
      queue.push(op)
      // if not started, start now
      if (!currentOp) nextUpload()
      return op
    }

    Files.upload = function(file:IHTMLFile) {
      console.log("UPLOAD", file.name, file.size)
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

    // simple queueing method for uploading?

    return Files
})

