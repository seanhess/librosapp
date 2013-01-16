///<reference path='../def/rethinkdb.d.ts'/>

import r = module('rethinkdb')

var books = r.table('books')

export interface IBook {
  bookId: string;
  title: string;
}

export function validate(book:IBook) {
  return true
}

export function init(db) {
  return db.tableCreate({tableName:'books', primaryKey:'bookId'})
}

// just makes the query, doesn't execute it.
export function saveBook(book:IBook) {
  return books.insert(book)
}

export function allBooks() {
  return r.db('libros').table('books')
}

export function getBook(bookId:string) {
  return books.get(bookId, "bookId")
}

export function removeBook(bookId:string) {
  return getBook(bookId).del()
}
