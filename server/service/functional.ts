
export function map(f:(item:Object) => Object) {
  return function(items:any[]) {
    return items.map(f)
  }
}

export function sort(array:any[]) { 
  return array.sort() 
}
