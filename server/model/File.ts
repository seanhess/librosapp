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
import store = module('../service/s3')

// var store:s3.Store = local

import db = module('./db')
import q = module('q')

var files = r.table('files')


/// QUERIES //////////////////////////////////////////

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
  return byFileId(fileId).update({name:file.name})
}

export function byBookId(bookId:string) {
  return files
  .filter(function(item:r.IObjectProxy) {
    return item.contains("bookId").and(item("bookId").eq(bookId))
  })
  .orderBy('name')
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



/// ACTIONS //////////////////////////////////////////

export function deleteFile(fileId:string) {
  return db.run(byFileId(fileId))
  .then(function(file:IFile) {
    if (!file) throw new Error("can not find fileId: " + fileId)
    return store.fileRemove(file)
    .then(() => db.run(remove(fileId)))
    .then(() => file)
  })
}

export function createFileFromUpload(uploadedFile:IUploadFile):q.IPromise {
  var file = toFile(uploadedFile)
  return store.fileUpload(file, uploadedFile)
  .then(() => db.run(insert(file)))
  .then(() => file)
}

export function isAudio(file:IFile) {
  return (file.ext == "mp3")
}
export function isText(file:IFile) {
  return !isAudio(file)
}

function toFile(source:IUploadFile):IFile {
  var ext = source.name.split('.').pop() // txt
  var name = path.basename(source.name, "."+ext)
  var file:IFile = {
   fileId: generateFileId(source), // fileId has the ext in it
   name: name,
   ext: ext,
  }
  file.url = store.fileToUrl(file)
  return file
}

function generateFileId(source:IUploadFile):string {
  var ext = source.name.split('.').pop() // txt
  var name = path.basename(source.name, "."+ext)
  var fileId = name.replace(/[^\w\.]+/g, "") + "_" + source.size + "." + ext
  return fileId
}

