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

  describe("books", function() {
    it('should create a book', function(done) {
      request.post({url: domain + '/books', json:{}}, (err, rs, body:IBook) => {
        assert.ifError(err)
        assert.equal(rs.statusCode, 200, body)
        assert.ok(body.bookId, "No bookId")
        this.bookId = body.bookId
        done()
      })
    })

    it('should return the book in books', function(done) {
      request.get({url: domain + '/books', json:true}, (err, rs, body:IBook[]) => {
        assert.ifError(err)
        assert.ok(body.length)
        assert.equal(rs.statusCode, 200, "ERROR ("+rs.statusCode+") "+body)
        var book = body.filter((book:IBook) => book.bookId == this.bookId)[0]
        assert.ok(book)
        assert.ok(!book.files, "should not have .files on large book list")
        done()
      })
    })

    it('should return the book details with a title', function(done) {
      request.get({url: domain + '/books/' + this.bookId, json:true}, (err, rs, book:IBook) => {
        assert.ifError(err)
        assert.ok(book)
        assert.ok(book.title, "Missing title")
        done()
      })
    })

    it('should save an update', function(done) {
      var book:IBook = {
        title: "title",
        bookId: this.bookId,
        author: "author",
        genre: "genre",
        popularity: 0,
        featured: false,
        description: "description",
      }

      request.put({url: domain + '/books/' + book.bookId, json:book}, (err, rs) => {
        assert.ifError(err)
        request.get({url: domain + '/books/' + book.bookId, json:true}, (err, rs, updated:IBook) => {
          assert.ok(updated)
          assert.equal(book.title, updated.title)
          assert.equal(book.author, updated.author)
          done()
        })
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
})
