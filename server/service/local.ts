///<reference path='../def/q.d.ts'/>
///<reference path='../types.ts'/>
///<reference path='../def/DefinitelyTyped/node/node.d.ts'/>

// file://localhost/Users/seanhess/Downloads/Dios%20y%20el%20Estado%203%20(1).html

import q = require('q')
import fs = require('fs')
import path = require('path')
import s3 = require("./s3")

interface FSPromise {
  writeFile(filename:string, data:any):q.IPromise<void>;
  readFile(filename:string):q.IPromise<string>;
  rename(oldpath:string, newpath:string):q.IPromise<void>;
  unlink(filename:string):q.IPromise<void>;
}

var fsp:FSPromise = {
  writeFile: <any> q.nfbind(fs.writeFile),
  readFile: <any> q.nfbind(fs.readFile),
  rename: <any> q.nfbind(fs.rename),
  unlink: <any> q.nfbind(fs.unlink),
}

var BASE_URL = "http://librosapp.tk/files_data"

// need more info that that! need the extention, etc
function toLocalPath(file:IFile):string {
  return "/var/www/files_data/" + file.fileId
}

export function fileRemove(file:IFile):q.IPromise<void> {
  return fsp.unlink(toLocalPath(file))
}

export function fileUpload(file:IFile, source:IUploadFile):q.IPromise<void> {
  return fsp.rename(source.path, toLocalPath(file))
}

export function fileToUrl(file:IFile):string {
  return BASE_URL + "/" + file.fileId
}

function fileToUrlPath(file:IFile):string {
  return "/file_data" + file.fileId
}


export function repairUrl(url:string):string {
  return url.replace(s3.bucketUrl, BASE_URL);
}

// export function removeUrl(file:IFile):q.IPromise {
//   return fsp.unlink(toLocalPath(file))
// }
