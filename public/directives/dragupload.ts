///<reference path="../def/angular.d.ts"/>
///<reference path="../def/jquery.d.ts"/>

angular.module('directives')

// prevents drops from changing the page
.directive('dragignore', function($parse:ng.IParseService) {
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

      var formData = new FormData()
      for (var i in files) {
        formData.append('files', files[i])
      }

      // you can post formData directly to the server. Will be under "files"
      onDrop(files, formData)
    })
  }
})

//.directive('focus', function() {
  //return function(scope:ng.IScope, element:JQuery, attrs) {
    //scope.$watch(attrs.focus, function(value) {
      //if (value) element.focus()
    //}) 
  //}
//})

//.directive('onEnter', function($parse:ng.IParseService) {
  //return function(scope:ng.IScope, element:JQuery, attrs) {
    //var onEnter = $parse(attrs.onEnter)
    //element.bind("keydown", function(e) {
      //if (e.keyCode == 13) {
        //onEnter(scope)
      //}
    //})
  //}
//})