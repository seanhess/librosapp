///<reference path='../def/rethinkdb.d.ts'/>
///<reference path='../def/async.d.ts'/>
///<reference path='../def/node-uuid.d.ts'/>
///<reference path='../def/knox.d.ts'/>
///<reference path='../types.ts'/>

// FILES are stored in their own table, associated with book via bookId
// the files are stored on the server, in a single folder, by fileId.ext

import r = module('rethinkdb')
import fs = module('fs')
import path = module('path')
import async = module('async')
import uuid = module('node-uuid')
import knox = module('knox')

import db = module('./db')
import q = module('q')

var BUCKET = "libros_pingplot"
var BUCKET_URL = "http://" + BUCKET + ".s3.amazonaws.com"
var s3client = knox.createClient({
  key:"AKIAICSJOXTYHJ3Z6TOQ",                         // DELETE ME (belongs to scott)
  secret:"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",
  bucket:BUCKET,
})

var files = r.table('files')

export interface IUploadFile {
  size: number; // 1304,
  path: string; // '/tmp/3a81a42308f94d3aac5bcf7b227aabfc',
  name: string; // 'BrantCooper.txt',
  type: string; // 'text/plain',
  hash: bool;   // false,
  lastModifiedDate: Date; // Thu Jan 17 2013 06:52:53 GMT-0700 (MST),
  length: number; // ??
  filename: string; // ??
  mime: string; // ??
}

function fileId(file:IFile) {
  return file.fileId
}

export function init(db) {
  return db.tableCreate({tableName:'files', primaryKey:'fileId'})
}

export function insert(file:IFile) {
  return files.insert(file)
}

// the only thing you can change is the name
export function update(fileId:string, file:IFile) {
  return files.update({fileId: fileId, name:file.name})
}

export function byBookId(bookId:string) {
  return files.filter({bookId: bookId}).orderBy('name')
}

export function byFileId(fileId:string) {
  return files.get(fileId, "fileId")
}

export function remove(fileId:string) {
  return byFileId(fileId).del()
}

export function filePath(fileId:string) {
  return path.join(__dirname, '..', 'files', fileId)
}

function toUrl(file:IFile):string {
  return BUCKET_URL + toUrlPath(file)
}

// need more info that that! need the extention, etc
function toUrlPath(file:IFile):string {
  return "/" + file.fileId + "." + file.ext
}

export function toFile(bookId:string, source:IUploadFile):IFile {
  var ext = source.name.split('.').pop() // txt
  var fileId = uuid.v1()
  var file:IFile = {
    bookId: bookId,
    name: path.basename(source.name, "."+ext),
    ext: ext,
    fileId: fileId,
    url: undefined,
  }
  file.url = toUrl(file)
  return file
}

export function uploadToUrl(file:IFile, source:IUploadFile) {
  var deferred = q.defer()
  s3client.putFile(source.path, toUrlPath(file), {'Content-Type':source.mime}, <knox.IResponseCallback> deferred.makeNodeResolver())
  return deferred.promise
}

export function removeUrl(file:IFile):q.IPromise {
  var deferred = q.defer()
  s3client.deleteFile(toUrlPath(file), <knox.IResponseCallback> deferred.makeNodeResolver())
  return deferred.promise
}

export function addFileForBook(bookId:string, uploadedFile:IUploadFile):q.IPromise {
  var file = toFile(bookId, uploadedFile)
  return uploadToUrl(file, uploadedFile)
  .then(() => db.run(insert(file)))
  .then(() => file)
}

export function deleteFile(fileId:string) {
  return db.run(byFileId(fileId))
  .then(removeUrl)
  .then(() => db.run(remove(fileId)))
}

// this returns a single promise
export function deleteFilesForBook(bookId:string) {
  return db.collect(byBookId(bookId))
  .then(function(files:IFile[]) {
    return q.all(files.map(fileId).map(deleteFile))
  })
}

export function isAudio(file:IFile) {
  return (file.ext == "mp3")
}
