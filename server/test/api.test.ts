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
  
  it('GET /books return 200',function(done){
    request.get(domain + '/books', function(err, rs) {
      assert.equal(rs.statusCode, 200)
      done()
    })
  });

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
})

