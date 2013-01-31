///<reference path='../def/rethinkdb.d.ts'/>
///<reference path='../types.ts'/>

import r = module('rethinkdb')
import db = module('./db')
import q = module('q')

var books = r.table('books')

export interface IdentifiedBook {
  bookId: string;
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
  return books.insert({title:"New Book"})
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

export function insertedBook(info:r.InsertResult):IdentifiedBook {
  return {bookId: info.generated_keys[0]}
}


function sort(array:any[]) { 
  return array.sort() 
}




export function getDistinctAuthors():q.IPromise {
  return db.collect(distinctAuthors()).then(sort)
}

export function getByAuthor(authorName:string) {
  return db.collect(byAuthor(authorName))
}

