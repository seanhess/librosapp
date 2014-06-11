///<reference path='def/DefinitelyTyped/express/express.d.ts' />
///<reference path='def/DefinitelyTyped/node/node.d.ts' />
///<reference path='def/rethinkdb.d.ts'/>

var PORT = process.env.PORT || 3000
import express = require('express')
import http = require('http')
var stylus = require('stylus')
var nib = require('nib')
var connect = require('connect')
var path = require('path')
var basicAuth = require('connect-basic-auth')

import db = require('model/db')

import r = require('rethinkdb')

import Book = require('model/Book')
import File = require('model/File')

function dbError(err) {
  throw new Error("RETHINKDB: " + err.message)
}

function ignoreError(err) {}

function connectdb(dbname:string) {
  console.log("rethinkdb://localhost:28015/" + dbname)
  r.connect({host:'localhost', port: 28015}, function(conn) {
      conn.run(r.dbCreate(dbname), function(err) {
        // ignore error (It's probably an already created error)
        var db = r.db(dbname)
        conn.use(dbname)
        conn.run(Book.init(db), ignoreError)
        conn.run(File.init(db), ignoreError)
      })
  }, dbError)
}

export var app = express()

app.configure("test", () => {
  console.log("TEST")
  connectdb('test')
})

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
app.use(connect.multipart())
app.use(connect.bodyParser())
app.use(connect.session({secret: 'funky monkey', key: 'blah', store:new connect.session.MemoryStore()}))

app.configure("production", () => {
  console.log("PRODUCTION")
  app.use(basicAuth(function(credentials, req, res, next) {
      if (credentials.username == "admin" && credentials.password == "Librosespanol3")
        next()
      else
        res.send(401)
  }, 'Please enter your credentials'))
  
  function requireAuth(req, res, next) {
      req.requireAuthorization(req, res, next)
  }
  
  app.all('/admin*', requireAuth)
  app.del('*', <any> requireAuth)
  app.post('*', <any> requireAuth)
  app.put('*', <any> requireAuth)
})

app.configure(() => {
  console.log("CONFIGURE")
  connectdb('libros')
})


// TODO validation
function send(res:ExpressServerResponse) {
  return function(value:any) {
    if (value) res.send(value)
    else res.send(404)
  }
}

function code(res:ExpressServerResponse, code:number) {
  return function() {
    res.send(code)
  }
}

function ok(res:ExpressServerResponse) {
  return function() {
    res.send(200)
  }
}

function err(res:ExpressServerResponse) {
  return function(err:Error) {
    res.send(500, err.message)
  }
}





/// GENRES ////////////////////////////

app.get('/genres', function(req, res) {
  Book.getDistinctGenres()
  .then(send(res), err(res))
})

app.get('/genres/:name/books', function(req, res) {
  db.collect(Book.byGenre(req.params.name))
  .then(send(res), err(res))
})



/// AUTHORS ////////////////////////////

app.get('/authors', function(req, res) {
  //db.collect(Book.distinctAuthors())
  Book.getDistinctAuthors()
  .then(send(res), err(res))
})

app.get('/authors/:authorName/books', function(req, res) {
  Book.getByAuthor(req.params.authorName)
  .then(send(res), err(res))
})






/// BOOKS ////////////////////////////

// does NOT include files!
app.get('/books', function(req, res) {
  Book.loadAllBooks()
  .then(send(res), err(res))
})

app.get('/books/:bookId', function(req, res) {
  Book.loadBook(req.params.bookId)
  .then(send(res), err(res))
})

app.del('/books/:bookId', function(req, res) {
  var bookId = req.params.bookId
  // don't worry about deleting files. since they overwrite each other
  // File.deleteFilesForBook(bookId)
  db.run(Book.removeBook(bookId))
  .then(send(res), err(res))
})

// create a new book, just an id really
app.post('/books', function(req, res) {
  db.run(Book.create())
  .then(Book.insertedBook)
  .then(send(res), err(res))
})

app.put('/books/:bookId', function(req, res) {
  Book.updateBook(req.body)
  .then(ok(res), err(res))
})

app.get('/books/:bookId/files', function(req, res) {
  Book.files(req.params.bookId)
  .then(send(res), err(res))
})

app.post('/books/migrations/popularity', function(req, res) {
  db.run(Book.migratePopularityFeatured())
  .then(send(res), ok(res))
})

// someone bought the book. track it
app.post('/books/:bookId/popularity', function(req, res) {
  db.run(Book.incrementPopularity(req.params.bookId))
  .then(send(res), ok(res))
})



/// FILES //////////////////////////////////////


// lets you multipart upload a file, and get back a valid File object
// expects a single multipart file
app.post('/files', function(req, res) {
  File.createFileFromUpload(req.files.file)
  .then(send(res), err(res))
})

app.del('/files/:fileId', function(req, res) {
   File.deleteFile(req.params.fileId)
   .then(ok(res), err(res))
})

app.get('/files/:fileId', function(req, res) {
  db.run(File.byFileId(req.params.fileId))
  .then(send(res), err(res))
})

// raw downloads are set to my public folder?
// or are otherwise publicly accessible? no, I'd rather control it I guess? Might as well though. nginx can serve files just fine

// edit the file metadata. move the file if you change the name?
// ALSO update the file on s3?
app.put('/files/:fileId', function(req, res) {
  db.run(File.update(req.params.fileId, req.body))
  .then(ok(res), err(res))
})


/// APP ///////////////////////////////////////////

// Send the Angular app for everything under /admin
// Be careful not to accidentally send it for 404 javascript files, or data routes
app.get(/\/admin[\w\/\-]*$/, function(req, res) {
  res.sendfile(path.join(__dirname, '..', 'public', 'app.html'))
})

app.get('/', function(req, res) {
    res.sendfile(__dirname+'/index.html')
})




if (module == (<any>require).main) {
  var server = http.createServer(app)
  server.listen(PORT, () => {
    console.log("RUNNING " + PORT)
  })
}
