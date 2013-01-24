///<reference path="./node.d.ts"/>

// See: https://github.com/kriskowal/q

declare module "q" {
  // all resolves with an array of values
  export function all(promises:IPromise[]):IPromise;

  // same as all, but waits for all of them
  export function allResolved(promises:IPromise[]):IPromise;

  // same as all, but spread solves with a bunch of parameters
  export function spread(promises:IPromise[]):IPromise;



  export function fcall(f:Function, ...args:any[]):IPromise;
  export function resolve(value:any):IPromise;
  export function defer():IDeferred;

  export function delay(ms:number):IPromise;
  export function timeout(promise:IPromise, ms:number):IPromise;

  // use to convert it to a Q promise
  export function when(valueOrPromise:Object, cb?:ResolveBack, eb?:ErrBack):IPromise;
  // + fail, fin, done? in case they aren't promises

  // lame way to invoke a function that returns a promise
  export function invoke(obj:Object, fname:string, ...args:any[]):IPromise;

  // Node invokers
  export function nfcall(f:Function, ...args:any[]):IPromise;
  export function nfinvoke(f:Function, fname:string, ...args:any[]):IPromise;
  export function nfbind(f:Function):Function; // converts node function to promise-compatible function minus args

  interface ResolveBack {
    (value:any):any;
  }

  interface ErrBack {
    (err:Error);
  }

  interface EmptyBack {
    ();
  }

  export interface IPromise extends IProxy {
    then(cb:ResolveBack, eb?:ErrBack):IPromise;
    fail(eb:ErrBack):IPromise;
    fin(cb:() => any):IPromise;
    done();

    // resolves with multiple params
    spread(cb:ResolveBack):IPromise;
  }

  export interface IProxy {
    get(key:string):IPromise;
    get(index:number):IPromise;
    put(key:string, value:any):IPromise;
    del(key:string):IPromise;
    post(key:string, args:any[]):IPromise;
    invoke(key:string, ...args:any[]):IPromise;
    fapply(args:any[]):IPromise;
    fcall(...args:any[]):IPromise;
  }

  export interface IDeferred {
    reject(err:Error);
    resolve(value:any);
    resolve(promise:IPromise);
    promise:IPromise;

    // makes a callback for node, when using Q.defer()
    makeNodeResolver():Function;
  }
}

