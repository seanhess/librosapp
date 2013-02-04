///<reference path='../def/rethinkdb.d.ts'/>
///<reference path='../types.ts'/>

import r = module('rethinkdb')
import db = module('./db')
import q = module('q')
import f = module('../service/functional')
import File = module('./File')

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

function fileCountUpdate(file:IFile) {
  var field = fileCountField(file)
  var update = {}
  update[field] = r.row(field).add(1)
  return getBook(file.bookId)
  .update(update)
}

function toNamedObject(name:string):INamedObject {
  return {name: name}
}


export function insertedBook(info:r.InsertResult):IdentifiedBook {
  return {bookId: info.generated_keys[0]}
}





// ACTIONS


export function distinctGenres() {
  return books
  .filter(function(book) {
    return book.contains('genre')
  })
  .map(function(book) {
    return book('genre')
  }).distinct()
}

export function distinctAuthors() {
  return books.map(function(book) {
    return book('author')
  }).distinct()
}


export function getDistinctAuthors():q.IPromise {
  return db.collect(distinctAuthors())
  .then(f.sort)
  .then(f.map(toNamedObject))
}

export function getDistinctGenres() {
  return db.collect(distinctGenres())
  .then(f.sort)
  .then(f.map(toNamedObject))
}

export function getByAuthor(authorName:string) {
  return db.collect(byAuthor(authorName))
}

export function countFile(file:IFile) {
  return db.run(fileCountUpdate(file))
  .then(() => file)
}


