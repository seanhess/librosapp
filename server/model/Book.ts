///<reference path='../def/rethinkdb.d.ts'/>
///<reference path='../types.ts'/>

import r = module('rethinkdb')
import db = module('./db')
import q = module('q')
import f = module('../service/functional')
import File = module('./File')

import store = module('../service/s3')

var books = r.table('books')

export interface IdentifiedBook {
  bookId: string;
}

function emptyBook():IBook {
  var book = {
    bookId: null,
    title: "New Book",
    author: null,
    genre: null,
    price: 0,
    description: "",

    audioFiles: 0,
    textFiles: 0,
  }

  delete book.bookId
  delete book.author
  delete book.genre

  return book
}

export function validate(book:IBook) {
  return true
}

export function init(db) {
  return db.tableCreate({tableName:'books', primaryKey:'bookId'})
}

// just makes the query, doesn't execute it.
export function saveBook(book:IBook) {
  var overwrite = !!book.bookId
  return books.insert(book, overwrite)
}

export function setImageUrl(bookId:string, imageUrl:string) {
  return getBook(bookId).update({imageUrl: imageUrl})
}

export function create():r.IQuery {
  return books.insert(emptyBook())
}

export function allBooks():r.IQuery {
  return r.table('books').orderBy('title')
}

export function getBook(bookId:string) {
  return books.get(bookId, "bookId")
}

export function removeBook(bookId:string) {
  return getBook(bookId).del()
}

export function byAuthor(authorName:string) {
  return books.filter({author: authorName}).orderBy('title')
}

export function byGenre(name:string) {
  return books.filter({genre: name}).orderBy('title')
}

function fileCountField(file:IFile) {
  if (File.isAudio(file))
    return 'audioFiles'
  else
    return 'textFiles'
}

function fileCountUpdate(file:IFile, amount:number = 1) {
  var field = fileCountField(file)
  var update = {}
  update[field] = r.row(field).add(amount)
  return getBook(file.bookId)
  .update(update)
}

function toNamedObject(name:string):INamedObject {
  return {name: name}
}

function toFullAuthor(no:INamedObject):IAuthor {
  var parts = no.name.split(/\s/)
  var lastName = parts.pop()
  var firstName = parts.join(" ")
    
  return {
    name: no.name,
    firstName: firstName,
    lastName: lastName,
  }
}

function authorLastFirst(author:IAuthor):string {
  return author.lastName + ", " + author.firstName
}


export function insertedBook(info:r.InsertResult):IdentifiedBook {
  return {bookId: info.generated_keys[0]}
}

export function distinctGenres() {
  return books
  .filter(db.contains('genre'))
  .map(db.property('genre'))
  .distinct()
}

export function distinctAuthors() {
  return books
  .filter(db.contains('author'))
  .map(db.property('author'))
  .distinct()
}

export function getDistinctAuthors():q.IPromise {
  return db.collect(distinctAuthors())
  .then(f.map(toNamedObject))
  .then(f.map(toFullAuthor))
  .then(f.sortBy(authorLastFirst))
}

export function getDistinctGenres() {
  return db.collect(distinctGenres())
  .then(f.sort)
  .then(f.map(toNamedObject))
}

export function getByAuthor(authorName:string) {
  return db.collect(byAuthor(authorName))
}

export function countFileAdd(file:IFile) {
  return db.run(fileCountUpdate(file))
  .then(() => file)
}

export function countFileDel(file:IFile) {
  if (!file.bookId) return q.fcall(() => file)
  return db.run(fileCountUpdate(file, -1))
  .then(() => file)
}

// returns imageUrl at the end...
export function setImage(bookId:string, file:IUploadFile) {
  var remotePath = bookToImageUrlPath(bookId, file)
  var imageUrl = store.fullUrl(remotePath)
  return store.upload(remotePath, file)
  .then(() => db.run(setImageUrl(bookId, imageUrl)))
  .then(function() { return {imageUrl:imageUrl} })
}

function bookToImageUrlPath(bookId:string, file:IUploadFile):string {
  return "/" + bookId + "." + store.ext(file)
}




