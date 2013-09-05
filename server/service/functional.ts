///<reference path='../def/DefinitelyTyped/underscore/underscore.d.ts'/>
import _ = require("underscore")

export function map<T,U>(f:(item:T) => U) {
  return function(items:T[]):U[] {
    return items.map(f)
  }
}

export function sort<T>(array:T[]) { 
  return array.sort()
}

export function sortBy<T, TSort>(f:(item:T) => TSort) {
  return function(array:T[]):T[] {
     return _.sortBy(array, f)
  }
}
