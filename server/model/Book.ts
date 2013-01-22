///<reference path='../def/rethinkdb.d.ts'/>
///<reference path='../types.ts'/>

import r = module('rethinkdb')

var books = r.table('books')

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

export function create() {
  return books.insert({title:"New Book"})
}

export function allBooks() {
  return r.db('libros').table('books').orderBy('title')
}

export function getBook(bookId:string) {
  return books.get(bookId, "bookId")
}

export function removeBook(bookId:string) {
  return getBook(bookId).del()
}

