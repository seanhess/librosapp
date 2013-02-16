///<reference path='../types.ts'/>

import knox = module('knox')
import q = module('q')

export interface Store {
  uploadAndSetUrl(file:IFile, source:IUploadFile):q.IPromise;
  removeUrl(file:IFile):q.IPromise;
}

var BUCKET = "librosapp"
var BUCKET_URL = "http://" + BUCKET + ".s3.amazonaws.com"
var s3client = knox.createClient({
  key:"AKIAIMGQVHF2DZ7UN32Q",                         // DELETE ME (belongs to scott)
  secret:"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",
  bucket:BUCKET,
})

function toUrl(file:IFile):string {
  return BUCKET_URL + toUrlPath(file)
}

// need more info that that! need the extention, etc
function toUrlPath(file:IFile):string {
  return "/" + file.fileId + "." + file.ext
}

export function uploadAndSetUrl(file:IFile, source:IUploadFile) {
  return uploadToUrl(file, source)
  .then(function() {
    file.url = toUrl(file)
    return file
  })
}

function uploadToUrl(file:IFile, source:IUploadFile) {
  var deferred = q.defer()
  s3client.putFile(source.path, toUrlPath(file), {'Content-Type':source.mime}, <knox.IResponseCallback> deferred.makeNodeResolver())
  return deferred.promise
}

export function removeUrl(file:IFile):q.IPromise {
  var deferred = q.defer()
  s3client.deleteFile(toUrlPath(file), <knox.IResponseCallback> deferred.makeNodeResolver())
  return deferred.promise
}
