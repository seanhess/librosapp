///<reference path='../def/rethinkdb.d.ts'/>

import r = module('rethinkdb')

var files = r.table('files')

export interface IFile {
  bookId: string;
  fileId: string;
  ext: string; // "txt" or "mp3"
}

export function init(db) {
  return db.tableCreate({tableName:'files', primaryKey:'fileId'})
}

export function save(file:IFile) {
  var overwrite = !!file.fileId
  return files.insert(file, overwrite)
}

export function byBookId(bookId:string) {
  return files.get(bookId, "bookId")
}

export function byFileId(fileId:string) {
  return files.get(fileId, "fileId")
}

export function remove(fileId:string) {
  return byFileId(fileId).del()
}



