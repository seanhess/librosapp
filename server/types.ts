
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
  genre: string;
  price: number; // in cents
  description: string;

  //downloads: string; // ?? Or should I do a join?
  //isAudio: bool;
  //isText: bool;

  // when you download a book with both audio and text, it is supposed to appear as TWO books in the system?
  // need to finish the wireframes to figure this out
  // also, isAudio and isText are CALCULATED properties
}


