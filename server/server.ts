///<reference path='def/node.d.ts' />
///<reference path='def/express.d.ts'/>
///<reference path='def/rethinkdb.d.ts'/>

var PORT = process.env.PORT || 3000
import exp = module('express')
var stylus = require('stylus')
var nib = require('nib')
var connect = require('connect')
var path = require('path')

import r = module('rethinkdb')

import Book = module('model/Book')
//import auth = module('auth/control')

function handleError(err) {
  if (err) throw err
}

function ignoreError(err) {}

// initialize the GLOBAL rethinkdb connection settings
r.connect({host:'localhost', port: 28015}, function(conn) {
    conn.run(r.dbCreate('libros'), function(err) {
      // ignore error (It's probably an already created error)
      var db = r.db('libros')
      conn.use('libros')
      conn.run(Book.init(db), ignoreError)
    })
}, handleError)

var app = exp()

app.configure("development", () => {
  console.log("DEVELOPMENT")
  app.use(stylus.middleware({
    src: '../public',
    compile: (str, path) => {
      return stylus(str).use(nib()).import('nib').set('filename', path)
    }
  }))
})

app.use(connect.static(__dirname + '/../public'))
app.use(connect.cookieParser())
app.use(connect.bodyParser())
//app.use(connect.session({secret: 'funky monkey', key: 'blah', store:new connect.session.MemoryStore()}))
//app.use(auth.routes)

app.get('/books', function(req, res) {
  Book.allBooks().run().collect(function(books) {
    res.send(books)
  })
})

app.get('/books/:bookId', function(req, res) {
  Book.getBook(req.params.bookId).run(function(book) {
    res.send(book)
  })
})

app.post('/books', function(req, res) {
  // TODO validate book
  var book = req.body
  Book.saveBook(book).run(function(err) {
    res.send(200)
  })
})

// Send the Angular app for everything under /admin
app.get(/\/admin[\w\/\-]*$/, function(req, res) {
  res.sendfile(path.join(__dirname, '..', 'public', 'index.html'))
})

app.listen(PORT, () => {
  console.log("RUNNING " + PORT)
})
