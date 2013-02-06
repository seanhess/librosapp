/*///<reference path="../../public/components/DefinitelyTyped/underscore/underscore.d.ts"/>*/

// Type definitions for Underscore 1.4
// Project: http://underscorejs.org/
// Definitions by: Boris Yankov <https://github.com/borisyankov/>
// Definitions: https://github.com/borisyankov/DefinitelyTyped


interface UnderscoreWrappedObject {
    value () : any;
}

interface TemplateSettings {
    evaluate?: RegExp;
    interpolate?: RegExp;
    escape?: RegExp;
}

interface ListIterator {
    (value, key, list?): void;
}

interface ObjectIterator {
    (element, index, list?): void;
}

declare module "underscore" {

    /****
     Collections
    *****/
    export function each(list: any[], iterator: ListIterator, context?: any): any[];
    export function each(object: any, iterator: ObjectIterator, context?: any): any[];
    export function forEach(list: any[], iterator: ObjectIterator, context?: any): any[];
    export function forEach(object: any, iterator: ListIterator, context?: any): any[];

    export function map(list: any[], iterator: ListIterator, context?: any): any[];
    export function map(object: any, iterator: ObjectIterator, context?: any): any[];
    export function collect(list: any[], iterator: ListIterator, context?: any): any[];
    export function collect(object: any, iterator: ObjectIterator, context?: any): any[];

    export function reduce(list: any[], iterator: any, memo: any, context?: any): any[];
    export function inject(list: any[], iterator: any, memo: any, context?: any): any[];
    export function foldl(list: any[], iterator: any, memo: any, context?: any): any[];

    export function reduceRight(list: any[], iterator: any, memo: any, context?: any): any[];
    export function foldr(list: any[], iterator: any, memo: any, context?: any): any[];

    export function find(list: any[], iterator: any, context?: any): any;
    export function detect(list: any[], iterator: any, context?: any): any;

    export function filter(list: any[], iterator: any, context?: any): any[];
    export function select(list: any[], iterator: any, context?: any): any[];

    export function where(list: any[], properties: any): any[];

    export function reject(list: any[], iterator: any, context?: any): any[];

    export function all(list: any[], iterator: any, context?: any): bool;
    export function every(list: any[], iterator: any, context?: any): bool;

    export function any(list: any[], iterator?: any, context?: any): bool;
    export function some(list: any[], iterator?: any, context?: any): bool;

    export function contains(list: any, value: any): bool;
    export function contains(list: any[], value: any): bool;
    export function include(list: any, value: any): bool;
    export function include(list: any[], value: any): bool;

    export function invoke(list: any[], methodName: string, arguments: any[]): any;
    export function invoke(object: any, methodName: string, ...arguments: any[]): any;

    export function pluck(list: any[], propertyName: string): string[];
    export function max(list: any[], iterator?: any, context?: any): any;
    export function min(list: any[], iterator?: any, context?: any): any;
    export function sortBy(list: any[], iterator?: any, context?: any): any;
    export function groupBy(list: any[], iterator: any): any;
    export function countBy(list: any[], iterator: any): any;
    export function shuffle(list: any[]): any[];
    export function toArray(list: any): any[];
    export function size(list: any): number;

    /****
     Arrays
    *****/
    export function first(array: any[], n?: number): any;
    export function head(array: any[], n?: number): any;
    export function take(array: any[], n?: number): any;

    export function initial(array: any[], n?: number): any[];

    export function last(array: any[], n?: number): any;

    export function rest(array: any[], n?: number): any[];
    export function tail(array: any[], n?: number): any[];
    export function drop(array: any[], n?: number): any[];

    export function compact(array: any[]): any[];
    export function flatten(array: any[], shallow?: bool): any[];
    export function without(array: any[], ...values: any[]): any[];
    export function union(...arrays: any[][]): any[];
    export function intersection(...arrays: any[][]): any[];
    export function difference(array: any[], ...others: any[][]): any[];

    export function uniq(array: any[], isSorted?: bool, iterator?: any): any[];
    export function unique(array: any[], isSorted?: bool, iterator?: any): any[];

    export function zip(...arrays: any[]): any[];
    export function object(list: any[], values: any[]): any;
    export function indexOf(array: any[], value: any, isSorted?: bool): number;
    export function lastIndexOf(array: any[], value: any, fromIndex?: number): number;
    export function sortedIndex(list: any[], valueL: any, iterator?: any): number;
    export function range(stop: number): any[];
    export function range(start: number, stop: number, step?: number): any[];

    /****
     Functions
    *****/
    export function bind(func: (...as : any[]) => any, context: any, ...arguments: any[]): () => any;
    export function bindAll(object: any, ...methodNames: string[]): any;
    export function memoize(func: any, hashFunction?: any): any;
    export function defer(func: () => any);
    export function delay(func: any, wait: number, ...arguments: any[]): any;
    export function delay(func: any, ...arguments: any[]): any;
    export function throttle(func: any, wait: number): any;
    export function debounce(func: any, wait: number, immediate?: bool): any;
    export function once(func: any): any;
    export function after(count: number, func: any): any;
    export function wrap(func: (...as : any[]) => any, wrapper: any): () => any;
    export function compose(...functions: any[]): any;

    /****
     Objects
    *****/
    export function keys(object: any): any[];
    export function values(object: any): any[];
    export function pairs(object: any): any[];
    export function invert(object: any): any;

    export function functions(object: any): string[];
    export function methods(object: any): string[];

    export function extend(destination: any, ...sources: any[]): any;
    export function pick(object: any, ...keys: string[]): any;
    export function omit(object: any, ...keys: string[]): any;
    export function defaults(object: any, ...defaults: any[]): any;
    export function clone(object: any): any;
    export function tap(object: any, interceptor: (...as : any[]) => any): any;
    export function has(object: any, key: string): bool;
    export function isEqual(object: any, other: any): bool;
    export function isEmpty(object: any): bool;
    export function isElement(object: any): bool;
    export function isArray(object: any): bool;
    export function isObject(value: any): bool;
    export function isArguments(object: any): bool;
    export function isFunction(object: any): bool;
    export function isString(object: any): bool;
    export function isNumber(object: any): bool;
    export function isFinite(object: any): bool;
    export function isBoolean(object: any): bool;
    export function isDate(object: any): bool;
    export function isRegExp(object: any): bool;
    export function isNaN(object: any): bool;
    export function isNull(object: any): bool;
    export function isUndefined(value: any): bool;

    /****
     Utility
    *****/
    export function noConflict(): any;
    export function identity(value: any): any;
    export function times(n: number, iterator: (index : number) => void, context?: any): void;
    export function random(min: number, max: number): number;
    export function mixin(object: any): void;
    export function uniqueId(prefix: string): string;
    export function uniqueId(): number;
    export function escape(str: string): string;
    export function result(object: any, property: string): any;
    export var templateSettings: TemplateSettings;
    export function template(templateString: string, data?: any, settings?: any): (...data: any[]) => string;

    /****
     Chaining
    *****/
    export function chain(object: any): UnderscoreWrappedObject;
}
