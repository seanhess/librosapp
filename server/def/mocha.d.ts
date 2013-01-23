declare module mocha {

  interface Errback {
    (err?:Error);
  }
  
  interface AsyncCB {
    (done:Errback);
  }
}

declare function describe(noun:string, cb:mocha.AsyncCB);
declare function it(should:string, cb?:mocha.AsyncCB);
declare function before(cb:mocha.AsyncCB);
