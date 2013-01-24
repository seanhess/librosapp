///<reference path="./node.d.ts"/>

declare module _deferred {
  interface IDeferred {
    promise:IPromise;
    resolve(asdf:any);
  }

  interface IPromise extends IEventEmitter {

  }
}

declare module "deferred" {
  export function ():_deferred.IDeferred;
}

