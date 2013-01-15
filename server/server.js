var PORT = process.env.PORT || 3000;
var exp = require('express')
var stylus = require('stylus');
var nib = require('nib');
var connect = require('connect');
var path = require('path');
var app = exp();
app.configure("development", function () {
    console.log("DEVELOPMENT");
    app.use(stylus.middleware({
        src: '../public',
        compile: function (str, path) {
            return stylus(str).use(nib()).import('nib').set('filename', path);
        }
    }));
});
app.use(connect.static(__dirname + '/../public'));
app.use(connect.cookieParser());
app.use(connect.bodyParser());
app.get('/books', function (req, res) {
    res.send([
        {
            bookId: "1",
            title: "one"
        }, 
        {
            bookId: "2",
            title: "two"
        }
    ]);
});
app.get('*', function (req, res) {
    res.sendfile(path.join(__dirname, '..', 'public', 'index.html'));
});
app.listen(PORT, function () {
    console.log("RUNNING " + PORT);
});

