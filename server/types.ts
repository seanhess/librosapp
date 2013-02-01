
// TYPES that are common throughout the whole system, front and back end
// to be included in either front-end or back end
// use <reference path="types.ts"> to load

interface IFile {
  bookId: string;
  fileId: string;
  name: string;
  ext: string; // "txt" or "mp3"
  url: string;
}

interface IBook {
  bookId: string;
  title: string;
  author: string;
  genre: string; // just the name
  price: number; // in cents
  description: string;

  // just make a check box for each one?
  // angular can set it for me! woot
  hasAudio: bool;
  hasText: bool;

  //downloads: string; // ?? Or should I do a join?
  //isAudio: bool;
  //isText: bool;
}

// a string masquerading as an object. Name is considered the primary key
interface INamedObject {
  name: string;
}

interface IAuthor extends INamedObject {}
interface IGenre extends INamedObject {}
