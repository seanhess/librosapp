
declare module "rethinkdb" {

  export function connect(host:IHost, onConnect?:(conn:IConnection) => void, onFailiure?:IErrorCb);
  export function dbCreate(name:string):IQuery;
  export function dbDrop(name:string):IQuery;
  export function dbList(name:string):IQuery;

  export function db(name:string):IDb;
  export function table(name:string):ITable;

  export function row(name:string):IRow;

  interface IHost {
    host:string;
    port:number;
  }

  interface IErrorCb {
    (err:Error, data?:any);
  }

  interface IQuery {
    run(cb?:IErrorCb):ICursor;
    runp(cb:IErrorCb);
    del():IQuery;
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

  interface ITable extends IQuery {
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
    filter(predicate:(obj:Object) => bool):IQuery;
  }

  interface IRow {
    gt(value:any):IRql;
  }

  interface IRql {}

  // http://www.rethinkdb.com/api/#js
  // TODO Joins
  // TODO Transformations
  // TODO Aggregation
  // TODO Reductions
  // TODO Document Manipulation
}
