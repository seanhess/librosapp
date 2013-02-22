///<reference path="../def/angular.d.ts"/>
///<reference path="../def/jquery.d.ts"/>


// prevents drops from changing the page
app.directive('dragignore', function($parse:ng.IParseService) {
  return function(scope:ng.IScope, element:JQuery, attrs) {
    var target = document

    target.addEventListener("dragover", function(e) {
      e.preventDefault()
      return false
    })

    target.addEventListener("drop", function(e) {
      e.preventDefault()
      return false
    })
  }
})

// dragupload="onDropFiles" will call scope.onDropFiles(files)
.directive('dragupload', function($parse:ng.IParseService) {
  return function(scope:ng.IScope, element:JQuery, attrs) {

    var target = element.get(0)
    //var onDrop = $parse(attrs.dragupload)
    var onDrop = scope[attrs.dragupload]

    //var onDrop = $parse(attrs.dragupload)

    //function shouldAccept(e) {
      //return (e.dataTransfer.files && e.dataTransfer.files.length && e.dataTransfer.files[0].type.match("text/plain"))
    //}

    target.addEventListener("dragenter", function(e) {
      element.addClass("drag")
    })

    target.addEventListener("dragleave", function(e) {
      element.removeClass("drag")
    })

    target.addEventListener("dragover", function(e) {
      e.stopPropagation()
      e.preventDefault()

      var ok = e.dataTransfer && e.dataTransfer.types && e.dataTransfer.types.indexOf('Files') >= 0

      return false
    })

    target.addEventListener("drop", function(e) {
      // dropped! Check out e.dataTransfer
      e.stopPropagation()
      e.preventDefault()
      element.removeClass("drag")

      //if (!shouldAccept(e)) return

      // convert files to array
      var files = Array.prototype.slice.call(e.dataTransfer.files, 0)

      scope.$apply(function() {
        onDrop(files)
      })
    })
  }
})

