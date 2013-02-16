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
import s3 = module('../service/s3')
import local = module('../service/local')

var store:s3.Store = local

import db = module('./db')
import q = module('q')

var files = r.table('files')

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
  //file.url = toUrl(file)
  return file
}

export function addFileForBook(bookId:string, uploadedFile:IUploadFile):q.IPromise {
  var file = toFile(bookId, uploadedFile)
  return store.uploadAndSetUrl(file, uploadedFile)
  .then((file) => db.run(insert(file)))
  .then(() => file)
}

export function deleteFile(fileId:string) {
  return db.run(byFileId(fileId))
  .then(function(file:IFile) {
    return store.removeUrl(file)
    .then(() => db.run(remove(fileId)))
    .then(() => file)
  })
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
