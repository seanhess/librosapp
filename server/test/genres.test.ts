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

  describe("genres", function() {

    // Or, should I have it simply return all the genres that exist on the books? The distinct genres?
    // Then I could use an autocomplete in the field instead
    // And to remove a genre, you have to remove all books that HAVE that genre
    // makes more sense and it's cool

    it('should create a book', function(done) {
      request.post({url: domain + '/books', json:{}}, (err, rs, body:IBook) => {
        assert.ifError(err)
        assert.equal(rs.statusCode, 200, body)
        assert.ok(body.bookId, "No bookId")
        this.bookId = body.bookId
        done()
      })
    })

    it('should save the genre', function(done) {
      var book:IBook = {
        title: "title",
        bookId: this.bookId,
        author: "Charles Dickens",
        genre: "Comedy",
        popularity: 0,
        featured: false,
        description: "description",
      }

      this.book = book

      request.put({url: domain + '/books/' + book.bookId, json:book}, (err, rs, body) => {
        assert.ifError(err)
        assert.equal(rs.statusCode, 200, "ERROR ("+rs.statusCode+") "+body)
        done()
      })
    })

    it('should return unique genres', function(done) {
      request.get({url: domain + '/genres/', json:true}, (err, rs, genres:IGenre[]) => {
        assert.ifError(err)
        assert.equal(rs.statusCode, 200)
        var matchingGenres = genres.filter((genre:IGenre) => genre.name == this.book.genre)
        assert.equal(matchingGenres.length, 1)
        done()
      })
    })

    it('should return books by genre', function(done) {
      request.get({url: domain + '/genres/'+this.book.genre+'/books', json:true}, (err, rs, books:IBook[]) => {
        assert.ifError(err)
        assert.equal(rs.statusCode, 200)
        assert.equal(books[0].genre, this.book.genre)
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
