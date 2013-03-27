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


// TODO what is up?
/// QUERIES //////////////////////////////////////////

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
  return books
  .filter(db.contains('title'))
  .orderBy(r.desc('featured'), r.desc('popularity'), r.asc('title'))
  .without('files')
}

export function getBook(bookId:string) {
  return books.get(bookId, "bookId")
}

export function removeBook(bookId:string) {
  return getBook(bookId).del()
}

export function byAuthor(authorName:string) {
  return books
  .filter((item) => item.contains("author").and(item("author").eq(authorName)))
  .orderBy('title')
}

export function byGenre(name:string) {
  return books
  .filter(function(item:r.IObjectProxy) {
    return item.contains("genre").and(item("genre").eq(name))
  })
  .orderBy('title')
}

export function migratePopularityFeatured() {
  return books.update({popularity: 0, featured: false})
}

export function incrementPopularity(bookId:string) {
  return getBook(bookId)
  .update({popularity: r.row('popularity').add(1)})
}


/// ACTIONS //////////////////////////////////////////

function setFileBookId(bookId:string) {
  return function(file:IFile) {
    file.bookId = bookId
    return file
  }
}

export function updateBook(book:IBook) {
  book = calculateNumFiles(book)
  return db.run(saveBook(book))
}

export function files(bookId:string) {
  return db.run(getBook(bookId))
  .then((book) => book.files.map(setFileBookId(bookId)))
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


/// DATA /////////////////////////////////////////

function calculateNumFiles(book:IBook) {
  book.files = book.files || []
  book.audioFiles = book.files.filter(File.isAudio).length
  book.textFiles = book.files.filter(File.isText).length
  return book
}

function emptyBook():IBook {
  var book = {
    bookId: null,
    title: "New Book",
    author: null,
    genre: null,
    popularity: 0,
    featured: false,
    description: "",

    audioFiles: 0,
    textFiles: 0,
    files: [],
  }

  delete book.bookId
  delete book.author
  delete book.genre

  return book
}

export function validate(book:IBook) {
  return true
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
