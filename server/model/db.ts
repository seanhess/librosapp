///<reference path='../def/q.d.ts'/>

// Contains some functions to help run rethinkdb queries and interface with express

import q = module('q')
import r = module('rethinkdb')

// wait, you're doing this wrong. 
// it executes it immediately
// we don't want to do it until we've hit the next step
export function collect(query:r.IQuery) {
  var def = q.defer()
  query.run().collect(function(info:any) {
    if (info instanceof Error) def.reject(info)
    else def.resolve(info)
  })
  return def.promise
}

export function run(query:r.IQuery) {
  var def = q.defer()
  query.run(function(info:any) {
    if (info instanceof Error) def.reject(info)
    else def.resolve(info)
  })
  return def.promise
}

export function contains(propertyName:string) {
  return function(item:r.IObjectProxy) {
    return item.contains(propertyName)
  }
}

export function property(propertyName:string) {
  return function(item:r.IObjectProxy) {
    return item(propertyName)
  }
}

