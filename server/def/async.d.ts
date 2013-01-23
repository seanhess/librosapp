///<reference path="../../public/components/DefinitelyTyped/async/async.d.ts"/>


declare module "async" {
    // Collections
    export function forEach(arr: any[], iterator: AsyncIterator, callback: AsyncCallback): void;
    export function forEachSeries(arr: any[], iterator: AsyncIterator, callback: AsyncCallback): void;
    export function forEachLimit(arr: any[], limit: number, iterator: AsyncIterator, callback: AsyncCallback): void;
    export function map(arr: any[], iterator: AsyncIterator, callback: AsyncCallback);
    export function mapSeries(arr: any[], iterator: AsyncIterator, callback: AsyncCallback);
    export function filter(arr: any[], iterator: AsyncIterator, callback: AsyncCallback);
    export function select(arr: any[], iterator: AsyncIterator, callback: AsyncCallback);
    export function filterSeries(arr: any[], iterator: AsyncIterator, callback: AsyncCallback);
    export function selectSeries(arr: any[], iterator: AsyncIterator, callback: AsyncCallback);
    export function reject(arr: any[], iterator: AsyncIterator, callback: AsyncCallback);
    export function rejectSeries(arr: any[], iterator: AsyncIterator, callback: AsyncCallback);
    export function reduce(arr: any[], memo: any, iterator: AsyncMemoIterator, callback: AsyncCallback);
    export function inject(arr: any[], memo: any, iterator: AsyncMemoIterator, callback: AsyncCallback);
    export function foldl(arr: any[], memo: any, iterator: AsyncMemoIterator, callback: AsyncCallback);
    export function reduceRight(arr: any[], memo: any, iterator: AsyncMemoIterator, callback: AsyncCallback);
    export function foldr(arr: any[], memo: any, iterator: AsyncMemoIterator, callback: AsyncCallback);
    export function detect(arr: any[], iterator: AsyncIterator, callback: AsyncCallback);
    export function detectSeries(arr: any[], iterator: AsyncIterator, callback: AsyncCallback);
    export function sortBy(arr: any[], iterator: AsyncIterator, callback: AsyncCallback);
    export function some(arr: any[], iterator: AsyncIterator, callback: AsyncCallback);
    export function any(arr: any[], iterator: AsyncIterator, callback: AsyncCallback);
    export function every(arr: any[], iterator: AsyncIterator, callback: AsyncCallback);
    export function all(arr: any[], iterator: AsyncIterator, callback: AsyncCallback);
    export function concat(arr: any[], iterator: AsyncIterator, callback: AsyncCallback);
    export function concatSeries(arr: any[], iterator: AsyncIterator, callback: AsyncCallback);

    // Control Flow
    export function series(tasks: any[], callback?: AsyncCallback): void;
    export function series(tasks: any, callback?: AsyncCallback): void;
    export function parallel(tasks: any[], callback?: AsyncCallback): void;
    export function parallel(tasks: any, callback?: AsyncCallback): void;
    export function whilst(test: Function, fn: Function, callback: AsyncCallback): void;
    export function until(test: Function, fn: Function, callback: AsyncCallback): void;
    export function waterfall(tasks: any[], callback?: AsyncCallback): void;
    export function waterfall(tasks: any, callback?: AsyncCallback): void;
    export function queue(worker: AsyncWorker, concurrency: number): AsyncQueue;
    //auto(tasks: any[], callback?: AsyncCallback): void;
    export function auto(tasks: any, callback?: AsyncCallback): void;
    export function iterator(tasks): Function;
    export function apply(fn: Function, ...arguments: any[]): void;
    export function nextTick(callback: AsyncCallback): void;

    // Utils
    export function memoize(fn: Function, hasher?: Function): Function;
    export function unmemoize(fn: Function): Function;
    export function log(fn: Function, ...arguments: any[]): void;
    export function dir(fn: Function, ...arguments: any[]): void;
    export function noConflict(): Async;
}
