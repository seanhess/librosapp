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

export function update(file:IFile) {
  return files.replace(file)
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

export function uploadToUrl(file:IFile, source:IUploadFile, cb:(err:Error) => void) {
  s3client.putFile(source.path, toUrlPath(file), {'Content-Type':source.mime}, cb)
}

export function removeUrl(file:IFile, cb:(err:Error) => void) {
  s3client.deleteFile(toUrlPath(file), function(err, res) {
    cb(err)
  })
}

export function addFileToBook(bookId:string, uploadedFile:IUploadFile, cb:(err:Error, file:IFile) => void) {
  var file = toFile(bookId, uploadedFile)
  uploadToUrl(file, uploadedFile, function(err) {
    if (err) return cb(err, null)
    insert(file).run(function(err) {
      // console.log("INSERTED", file, (info instanceof Error))
      if (err instanceof Error) return cb(err, null)
      cb(null, file)
    })
  })
}

export function addFilesToBook(bookId:string, uploadedFiles:IUploadFile[], cb:(err:Error, files:IFile[]) => void) {
  async.map(uploadedFiles, function(uploadedFile:IUploadFile, done) {
    addFileToBook(bookId, uploadedFile, done)
  }, <AsyncCallback> <any> cb)
}


export function deleteFile(fileId:string, cb:(err:Error) => void) {
  byFileId(fileId).run(function(file:IFile) { 
    removeUrl(file, function(err) {
      if (err) return cb(err)
      remove(fileId).run(cb)
    })
  })
}

export function deleteFilesForBook(bookId:string, cb:(err:Error) => void) {
  byBookId(bookId).run().collect(function(files:IFile[]) {
    //var fileIds = files.map(fileId)
    async.forEach(files, function(file:IFile, done) {
      deleteFile(file.fileId, done)
    }, <AsyncCallback> <any> cb)
  })
}
