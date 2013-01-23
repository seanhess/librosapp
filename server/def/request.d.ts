declare module "request" {
  
  import http = module('http')

  interface ResponseCB {
    (err:Error, rs:http.ServerResponse, body:any);
  }

  interface Options {
    url: string;
    json: any; // true or object
  }

  function get(url:string, cb:ResponseCB);
  function get(options:Options, cb:ResponseCB);

  function post(url:string, formData:Object, cb:ResponseCB);
  function post(options:Options, cb:ResponseCB);

  function put(url:string, formData:Object, cb:ResponseCB);
  function put(options:Options, cb:ResponseCB);

  function del(url:string, cb:ResponseCB);
  function del(options:Options, cb:ResponseCB);
}
