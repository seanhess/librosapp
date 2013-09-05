///<reference path="../def/angular.d.ts"/>
console.log("LOADED")

function toProductId() {
  return function(id:string) {
    if (!id) return
    return id.replace(/-/g, "_")
  }
}