
declare module "rethinkdb" {

  export function connect(host:IHost, onConnect?:(conn:IConnection) => void, onFailiure?:IErrorCb);
  export function dbCreate(name:string):IQuery;
  export function dbDrop(name:string):IQuery;
  export function dbList(name:string):IQuery;

  export function db(name:string):IDb;
  export function table(name:string):ITable;

  export function row(name:string):IRow;
  
  export function asc(property:string):ISort;
  export function desc(property:string):ISort;

  interface IHost {
    host:string;
    port:number;
  }

  interface IErrorCb {
    (err:Error, data?:any);
  }

  interface IQuery extends ISelection {
    run(cb?:Function):ICursor;
    runp(cb:Function);
    del():IQuery;
    orderBy(...keys:string[]):IQuery;
    orderBy(...sorts:ISort[]):IQuery;
    skip(n:number):IQuery;
    limit(n:number):IQuery;
    slice(start:number, end?:number):IQuery;
    nth(n:number):IQuery;
    pluck(...keys:string[]):IQuery;
    without(...keys:string[]):IQuery;
    update(updates:Object):IQuery;
    map(transformer:(obj:IObjectProxy) => any):IQuery;
    distinct():IQuery;
  }
  
  interface ISort {}

  interface InsertResult {
    generated_keys:string[];
  }

  interface IConnection {
    close();
    reconnect();
    use(dbName:string);
    run(query:IQuery, cb:IErrorCb):ICursor;
    runp(query:IQuery); // shortcut to dump results
  }

  interface ICursor {
    next(cb:(row:Object) => void);
    collect(cb:(rows:Object[]) => void);
  }

  interface IDb {
    tableCreate(name:string):IQuery;
    tableCreate(options:ITableOptions):IQuery;
    tableDrop(name:string):IQuery;
    tableList():IQuery;
    table(name:string, allowOutOfDate?:bool):ITable;
  }

  interface ITable extends IQuery, ISelection {
    insert(obj:Object, overwrite?:bool):IQuery;
    insert(obj:Object[]):IQuery;
    update(obj:Object):IQuery;
    replace(obj:Object):IQuery;
    del():IQuery;

    get(key:string, attributeName?:string):IQuery;
  }

  interface ITableOptions {
    tableName:string;
    primaryKey?:string;
  }

  interface ISelection {
    between(lower:any, upper:any, primaryKey?:string):IQuery;
    filter(obj:Object):IQuery;
    filter(rql:IRql):IQuery;
    filter(predicate:(obj:IObjectProxy) => bool):IQuery;
  }

  interface IRow {
    gt(value:any):IRql;
    add(num:number):IRow;
    sub(num:number):IRow;
    mul(num:number):IRow;
    div(num:number):IRow;
  }

  interface IExpression {
    contains(property:string):IExpression;
    eq(value:any):IExpression;
    and(expression:IExpression):IExpression;
  }
  
  interface IObjectProxy extends IExpression {
    (property:string):IExpression;
  }

  interface IRql {}

  // http://www.rethinkdb.com/api/#js
  // TODO Joins
  // TODO Transformations
  // TODO Aggregation
  // TODO Reductions
  // TODO Document Manipulation
}
