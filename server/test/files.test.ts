
///<reference path='../def/node.d.ts' />
///<reference path='../def/mocha.d.ts' />
///<reference path='../def/request.d.ts' />
///<reference path='../types' />

var assert = require('assert')
import server = module('../server')
import request = module('request')
import fs = module('fs')
import path = module('path')
var http = require('http')

describe("API", function() {

  var domain = null

  before(function(done) {
    var httpServer = http.createServer(server.app)
    httpServer.listen(0, function() {
      var addr = httpServer.address()
      domain = "http://" + addr.address + ":" + addr.port
      done()
    })
  })
  
  describe("files", function() {

    it('should create a book', function(done) {
      request.post({url: domain + '/books', json:{}}, (err, rs, body:IBook) => {
        assert.ifError(err)
        assert.ok(body.bookId, "No bookId")
        this.bookId = body.bookId
        done()
      })
    })

    it('should upload a file for the book', function(done) {
      var r = request.post({url: domain + '/books/' + this.bookId + '/files', json:true}, function(err, rs, file:IFile) {
        assert.ifError(err)
        assert.equal(rs.statusCode, 200, "Status("+rs.statusCode+"): " + file)
        assert.ok(file.fileId)
        done()
      })
      var form = r.form()
      form.append('file', fs.createReadStream(path.join(__dirname, 'data.txt')))
    })

    it('should return the files for a book', function(done) {
      request.get({url:domain+'/books/'+this.bookId+'/files', json:true}, (err, rs, files:IFile[]) => {
        assert.ifError(err)
        assert.equal(files.length, 1)
        this.file = files[0]
        assert.equal(this.file.name, "data") // data.txt
        assert.equal(this.file.ext, "txt")
        done()
      })
    })

    it('should have incremented the file info', function(done) {
      request.get({url: domain + '/books/' + this.bookId, json:true}, (err, rs, book:IBook) => {
        assert.ifError(err)
        assert.equal(rs.statusCode, 200)
        assert.equal(book.textFiles, 1)
        assert.equal(book.audioFiles, 0)
        done()
      })
    })

    it('should have uploaded the file to url', function(done) {
       
      var localFileMatch = this.file.url.match(/^file:\/\/localhost/)

      if (localFileMatch) {
        fs.readFile(this.file.url.replace(localFileMatch[0], ""), function(err, body) {
          assert.ifError(err)
          var asdf = body.toString()
          assert.ok(asdf.match('data'))
          done()
          
          })
        return;
      }

      request.get(this.file.url, (err, rs, body:string) => {
        assert.ifError(err)
        assert.equal(rs.statusCode, 200)
        assert.ok(body.match("data"))
        done()
      })
    })

    it('should save changes to a file', function(done) {
      var file:IFile = {
        name:"asdf",
        ext:"fake",
        fileId:"fake",
        url:"fake",
        bookId:"fake",
      }
      request.put({url:domain+'/files/'+this.file.fileId, json:file}, (err, rs) => {
        assert.ifError(err)
        assert.equal(rs.statusCode, 200)

        request.get({url:domain+'/books/'+this.bookId+'/files', json:true}, (err, rs, files:IFile[]) => {
          assert.ifError(err)
          assert.equal(files.length, 1)
          var updated = files[0]
          assert.equal(updated.name, "asdf", "didn't update. maybe it updated the fileId") // data.txt
          assert.equal(updated.ext, "txt", "changed extension!")
          assert.equal(updated.url, this.file.url)
          done()
        })
      })
    })

    it('should delete the file', function(done) {
      request.del(domain + '/files/' + this.file.fileId, (err, rs, body) => {
        assert.ifError(err)
        assert.equal(rs.statusCode, 200, "Status(" + rs.statusCode + "): " + body)
        request.get({url: domain + '/books/' + this.bookId + '/files', json:true}, (err, rs, files:IFile[]) => {
          assert.ifError(err)
          assert.equal(rs.statusCode, 200, "Status(" + rs.statusCode + "): " + files)
          assert.equal(files.length, 0)
          done()
        })
      })
    })

    it('should have decremented the file info', function(done) {
      request.get({url: domain + '/books/' + this.bookId, json:true}, (err, rs, book:IBook) => {
        assert.ifError(err)
        assert.equal(rs.statusCode, 200)
        assert.equal(book.textFiles, 0)
        assert.equal(book.audioFiles, 0)
        done()
      })
    })

    it('should delete the book', function(done) {
      request.del({url: domain + '/books/' + this.bookId, json:true}, (err, rs) => {
        assert.ifError(err)
        request.get({url: domain + '/books/' + this.bookId, json:true}, (err, rs) => {
          assert.ifError(err)
          assert.equal(rs.statusCode, 404)
          done()
        })
      })
    })
  })

  describe("angular app", function() {
    it('should return the app for an arbitrary url', function(done) {
      request.get(domain + "/admin/asdfjl", function(err, rs, body) {
        assert.equal(rs.statusCode, 200)
        done()
      })
    })

    it('should not return the app for missing files', function(done) {
      request.get(domain + "/fat.js", function(err, rs, body) {
        assert.equal(rs.statusCode, 404)
        done()
      })
    })

  })

  //it('should delete a book')


})
