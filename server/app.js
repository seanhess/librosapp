var express = require('express')

var app = express()


// should I actually start making the store?
// no, not really
// ooh! try rethinkdb

app.get('/books', function(req, res) {
    res.send([{bookId: "1", title:"one"}, {bookId: "2", title:"two"}, {bookId: "3", title:"wahoo"}])
})

app.listen(3000)
