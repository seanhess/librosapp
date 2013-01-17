
declare module "node-uuid" {

  export interface IOptions {
    node?: number[]; // array of 6 bytes
    clockseq?: number; // between 0-0x3fff
    msecs?: number; // unix timestamp
    nsecs?: number; //// extra nanoseconds 0-9999
  }

  export function v1(options?:IOptions, buffer?:Array, offset?:number):string;
  export function v4(options?:IOptions, buffer?:Array, offset?:number):string;
}
