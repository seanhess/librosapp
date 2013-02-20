///<reference path='../def/q.d.ts'/>
///<reference path='../types.ts'/>

// file://localhost/Users/seanhess/Downloads/Dios%20y%20el%20Estado%203%20(1).html

import q = module('q')
import fs = module('fs')
import path = module('path')

interface FSPromise {
  writeFile(filename:string, data:any);
  readFile(filename:string);
  unlink(filename:string);
}

var fsp:FSPromise = {
  writeFile: <any> q.nfbind(fs.writeFile),
  readFile: <any> q.nfbind(fs.readFile),
  unlink: <any> q.nfbind(fs.unlink),
}

var BASE_URL = "file://localhost"

function toUrl(file:IFile):string {
  return BASE_URL + toLocalPath(file)
}

// need more info that that! need the extention, etc
function toLocalPath(file:IFile):string {
  return "/tmp/" + file.fileId + "." + file.ext
}

export function fileUploadAndSetUrl(file:IFile, source:IUploadFile) {
  return fsp.readFile(source.path)
  .then((data) => fsp.writeFile(toLocalPath(file), data))
  .then(function() {
    file.url = toUrl(file)
    return file
  })
}

export function removeUrl(file:IFile):q.IPromise {
  return fsp.unlink(toLocalPath(file))
}
