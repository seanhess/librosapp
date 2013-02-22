
// TYPES that are common throughout the whole system, front and back end
// to be included in either front-end or back end
// use <reference path="types.ts"> to load

interface IFile {
  bookId?: string;
  fileId: string;
  name: string;
  ext: string; // "txt" or "mp3"
  url?: string;
}

interface IBook {
  bookId: string;
  title: string;
  author: string;
  genre: string; // just the name
  price: number; // in cents
  description: string;
  imageUrl?: string;

  audioFiles: number;
  textFiles: number;
}

// a string masquerading as an object. Name is considered the primary key
interface INamedObject {
  name: string;
}

interface IAuthor extends INamedObject {
  firstName: string;
  lastName: string;
}

interface IGenre extends INamedObject {}

interface IUploadFile {
  size: number; // 1304,
  path: string; // '/tmp/3a81a42308f94d3aac5bcf7b227aabfc',
  name: string; // 'BrantCooper.txt',
  type: string; // 'text/plain',
  hash: bool;   // false,
  lastModifiedDate: Date; // Thu Jan 17 2013 06:52:53 GMT-0700 (MST),
  length: number; // ??
  filename: string; // ??
  mime: string; // ??
}

