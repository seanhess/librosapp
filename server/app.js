var express = require('express')

var app = express()

app.get('/books/initial', function(req, res) {
    res.send([{age: "1", title:"one"}, {age: "2", title:"two"}])
})

app.listen(3000)
