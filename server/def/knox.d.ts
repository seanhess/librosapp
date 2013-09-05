///<reference path='DefinitelyTyped/node/node.d.ts' />

declare module "knox" {

  import http = require("http")

  export function createClient(options:IOptions):IClient;

  export interface IOptions {
    key: string;
    secret: string;
    bucket: string;
  }

  export interface IResponse {
    statusCode: number;
  }

  export interface IResponseCallback { 
    (err:Error, res:http.ClientResponse);
  }

  // both emit error(err), progress(done, total), and end()
  export interface IClient {
    putFile(localPath:string, remotePath:string, cb:IResponseCallback);
    putFile(localPath:string, remotePath:string, headers:Object, cb:IResponseCallback);

    deleteFile(removePath:string, cb:IResponseCallback);
  }
}


