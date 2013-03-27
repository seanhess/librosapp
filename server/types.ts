
// TYPES that are common throughout the whole system, front and back end
// to be included in either front-end or back end
// use <reference path="types.ts"> to load

interface IFile {
  bookId?: string; // pretend they belong to a book
  fileId: string;
  name: string;
  ext: string; // "txt" or "mp3"
  url?: string;
}

interface IBook {
  // prices are now tracked only in itunes connect
  bookId: string;
  title: string;
  author: string;
  genre: string; // just the name
  description: string;
  imageUrl?: string;
  popularity: number; // number of times it has been purchased
  featured: bool;

  audioFiles: number;
  textFiles: number;

  // store all the file objects in here? why not? can calculate EVERYTHING. wahoo
  files: IFile[];
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

