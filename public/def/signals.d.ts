declare module signals {

  //http://millermedeiros.github.com/js-signals/docs/symbols/Signal.html
  export interface ISignal {
    active:bool;
    memorize:bool;
    VERSION:string;

    // listeners can be pretty much anything. since you can dispatch anything
    add(listener:Function, listenerContext?:any, priority?:number);
    addOnce(listener:Function, listenerContext?:any, priority?:number);
    dispatch:Function;
    dispose();
    forget();
    getNumListeners():number;
    halt();
    has(listener:Function, context:any):bool;
    remove(listener:Function, context:any):Function;
    removeAll();
    toString():string;
  }

  declare class Signal implements ISignal {
    active:bool;
    memorize:bool;
    VERSION:string;

    // listeners can be pretty much anything. since you can dispatch anything
    add(listener:Function, listenerContext?:any, priority?:number);
    addOnce(listener:Function, listenerContext?:any, priority?:number);
    dispatch:Function;
    dispose();
    forget();
    getNumListeners():number;
    halt();
    has(listener:Function, context:any):bool;
    remove(listener:Function, context:any):Function;
    removeAll();
    toString():string;
  }
}
