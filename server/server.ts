///<reference path='def/node.d.ts' />
///<reference path="def/express.d.ts"/>

var PORT = process.env.PORT || 3000
import exp = module('express')
var stylus = require('stylus')
var nib = require('nib')
var connect = require('connect')
var path = require('path')

//import auth = module('auth/control')

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
  res.send([{bookId: "1", title: "one"}, {bookId: "2", title: "two"}])
})

app.post('/books', function(req, res) {
  res.send(200)
})

// Send the Angular app for everything. 
// So we can use HTML5 mode
app.get(/^[a-zA-Z\/\-\_]+$/, function(req, res) {
  res.sendfile(path.join(__dirname, '..', 'public', 'index.html'))
})

app.listen(PORT, () => {
  console.log("RUNNING " + PORT)
})
