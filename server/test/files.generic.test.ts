
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

  describe("generic files", function() {
    it('should upload a single file', function(done) {
      var r = request.post({url: domain + '/files', json:true}, (err, rs, file:IFile) => {
        assert.ifError(err)
        assert.equal(rs.statusCode, 200, "Status("+rs.statusCode+"): " + file)
        assert.ok(file.fileId)
        assert.ok(file.url)
        assert.ok(file.url.match(".txt"), "doesn't have extnsion")
        assert.ok(file.name)
        assert.ok(file.ext)
        this.file = file
        done()
      })
      var form = r.form()
      form.append('file', fs.createReadStream(path.join(__dirname, 'data.txt')))
    })

    it('should exist on the store', function(done) {
      request.get({url:this.file.url, json:true}, (err, rs, data) => {
        assert.ifError(err)
        assert.equal(rs.statusCode, 200)
        assert.ok(data)
        done()
      })
    })

    it('should have details', function(done) {
      request.get({url:domain + '/files/' + this.file.fileId, json:true}, (err, rs, file:IFile) => {
        assert.ifError(err)
        assert.equal(rs.statusCode, 200, "ERROR (" + rs.statusCode + ") " + file)
        assert.equal(file.fileId, this.file.fileId)
        done()
      })
    })

    it('should replace the file if uploaded twice', function(done) {
      var r = request.post({url: domain + '/files', json:true}, (err, rs, file:IFile) => {
        assert.ifError(err)
        assert.equal(rs.statusCode, 200, "Status("+rs.statusCode+"): " + file)
        assert.ok(file.fileId)
        assert.ok(file.url)
        assert.ok(file.name)
        assert.ok(file.ext)
        assert.equal(file.fileId, this.file.fileId)
        assert.equal(file.url, this.file.url)
        done()
      })
      var form = r.form()
      form.append('file', fs.createReadStream(path.join(__dirname, 'data.txt')))
    })

    it('should remove the file', function(done) {
      request.del({url:domain + '/files/' + this.file.fileId, json:true}, (err, rs, body) => {
        assert.ifError(err)
        assert.equal(rs.statusCode, 200, "ERROR (" + rs.statusCode + ") " + body)
        done()
      })
    })

    it('should NOT exist on the store', function(done) {
      request.get({url:this.file.url, json:true}, (err, rs, data) => {
        assert.ifError(err)
        assert.notEqual(rs.statusCode, 200)
        assert.ok(data)
        done()
      })
    })
  })
})
