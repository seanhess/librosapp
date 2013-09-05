///<reference path='../def/DefinitelyTyped/underscore/underscore.d.ts'/>
import _ = require("underscore")

export function map(f:(item:Object) => Object) {
  return function(items:any[]) {
    return items.map(f)
  }
}

export function sort(array:any[]) { 
  return array.sort() 
}

export function sortBy(f:(item:Object) => Object) {
  return function(array:Object[]) {
     return _.sortBy(array, f)
  }
}
