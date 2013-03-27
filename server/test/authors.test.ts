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

  describe("authors", function() {

    it('should create a book', function(done) {
      request.post({url: domain + '/books', json:{}}, (err, rs, body:IBook) => {
        assert.ifError(err)
        assert.equal(rs.statusCode, 200, body)
        assert.ok(body.bookId, "No bookId")
        this.bookId = body.bookId
        done()
      })
    })

    it('should save the author', function(done) {
      var book:IBook = {
        title: "title",
        bookId: this.bookId,
        author: "Charles Dickens",
        genre: "genre",
        description: "description",
        popularity: 0,
        featured: false,
      }

      this.book = book

      request.put({url: domain + '/books/' + book.bookId, json:book}, (err, rs) => {
        assert.ifError(err)
        assert.equal(rs.statusCode, 200)
        done()
      })
    })

    it('should return unique authors', function(done) {
      request.get({url: domain + '/authors/', json:true}, (err, rs, authors:IAuthor[]) => {
        assert.ifError(err)
        assert.equal(rs.statusCode, 200)
        var matchingAuthors = authors.filter((author:IAuthor) => author.name == this.book.author)
        assert.equal(matchingAuthors.length, 1)
        assert.ok(authors.filter((author:IAuthor) => author.firstName == "Charles").length)
        assert.ok(authors.filter((author:IAuthor) => author.lastName == "Dickens").length)
        done()
      })
    })

    it('should return books by author', function(done) {
      request.get({url: domain + '/authors/'+this.book.author+'/books', json:true}, (err, rs, books:IBook[]) => {
        assert.ifError(err)
        assert.equal(rs.statusCode, 200)
        assert.equal(books[0].author, this.book.author)
        assert.ok(books.filter((book:IBook) => book.bookId == this.book.bookId).length)
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
})
