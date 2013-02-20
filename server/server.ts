///<reference path='def/node.d.ts' />
///<reference path='def/express.d.ts'/>
///<reference path='def/rethinkdb.d.ts'/>

var PORT = process.env.PORT || 3000
import exp = module('express')
import http = module('http')
var stylus = require('stylus')
var nib = require('nib')
var connect = require('connect')
var path = require('path')

import db = module('model/db')

import r = module('rethinkdb')

import Book = module('model/Book')
import File = module('model/File')

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

export var app:exp.ServerApplication = exp()

app.configure("test", () => {
  console.log("TEST")
  connectdb('test')
})

app.configure("development", () => {
  console.log("DEVELOPMENT")
  connectdb('libros')
  app.use(stylus.middleware({
    src: '../public',
    compile: (str, path) => {
      return stylus(str).use(nib()).import('nib').set('filename', path)
    }
  }))
})

app.configure(() => {
  console.log("CONFIGURE")
})

app.use(connect.static(__dirname + '/../public'))
app.use(connect.cookieParser())
app.use(connect.multipart())
app.use(connect.bodyParser())
app.use(connect.session({secret: 'funky monkey', key: 'blah', store:new connect.session.MemoryStore()}))

// TODO validation
function send(res:exp.ServerResponse) {
  return function(value:any) {
    if (value) res.json(value)
    else res.send(404)
  }
}

function code(res:exp.ServerResponse, code:number) {
  return function() {
    res.send(code)
  }
}

function ok(res:exp.ServerResponse) {
  return function() {
    res.send(200)
  }
}

function err(res:exp.ServerResponse) {
  return function(err:Error) {
    res.send(500, err.message)
  }
}


// should I pretend that these are full objects?
// definitely makes it easier for my other system eh?
// don't have to store them that way!
app.get('/genres', function(req, res) {
  Book.getDistinctGenres()
  .then(send(res), err(res))
})

app.get('/genres/:name/books', function(req, res) {
  db.collect(Book.byGenre(req.params.name))
  .then(send(res), err(res))
})



app.get('/authors', function(req, res) {
  //db.collect(Book.distinctAuthors())
  Book.getDistinctAuthors()
  .then(send(res), err(res))
})

app.get('/authors/:authorName/books', function(req, res) {
  Book.getByAuthor(req.params.authorName)
  .then(send(res), err(res))
})




app.get('/books', function(req, res) {
  db.collect(Book.allBooks())
  .then(send(res), err(res))
})

app.get('/books/:bookId', function(req, res) {
  db.run(Book.getBook(req.params.bookId))
  .then(send(res), err(res))
})

app.del('/books/:bookId', function(req, res) {
  var bookId = req.params.bookId
  File.deleteFilesForBook(bookId)
  .then(() => db.run(Book.removeBook(bookId)))
  .then(send(res), err(res))
})

// create a new book, just an id really
app.post('/books', function(req, res) {
  db.run(Book.create())
  .then(Book.insertedBook)
  .then(send(res), err(res))
})

app.put('/books/:bookId', function(req, res) {
  db.run(Book.saveBook(req.body))
  .then(ok(res), err(res))
})

app.get('/books/:bookId/files', function(req, res) {
  db.collect(File.byBookId(req.params.bookId))
  .then(send(res), err(res))
})

app.put('/books/:bookId/image', function(req, res) {
  Book.setImage(req.params.bookId, req.files.file)
  .then(send(res), err(res))
})

app.del('/files/:fileId', function(req, res) {
  File.deleteFile(req.params.fileId)
  .then(Book.countFileDel)
  .then(ok(res), err(res))
})

// edit the file metadata. move the file if you change the name?
// ALSO update the file on s3?
app.put('/files/:fileId', function(req, res) {
  db.run(File.update(req.params.fileId, req.body))
  .then(ok(res), err(res))
})

// upload a single new file (doesn't do more than one)
app.post('/books/:bookId/files', function(req, res) {
  File.addFileForBook(req.params.bookId, req.files.file)
  .then(Book.countFileAdd)
  .then(send(res), err(res))
})

// Send the Angular app for everything under /admin
// Be careful not to accidentally send it for 404 javascript files, or data routes
app.get(/\/admin[\w\/\-]*$/, function(req, res) {
  res.sendfile(path.join(__dirname, '..', 'public', 'index.html'))
})


if (module == (<any>require).main) {
  var server = http.createServer(app)
  server.listen(PORT, () => {
    console.log("RUNNING " + PORT)
  })
}
