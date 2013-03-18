//
//  ReaderFormatter.h
//  Libros
//
//  Created by Sean Hess on 1/25/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBParsedString.h"
#import "File.h"

typedef enum {
    ReaderFontEmpty = 0,
    ReaderFontPalatino = 1,
    ReaderFontHoefler,
    ReaderFontTimesNewRoman,
    ReaderFontHelvetica,
    ReaderFontVerdana,
} ReaderFont;

@interface ReaderFormatter : NSObject

-(NSAttributedString*)textForFile:(File*)file withFont:(ReaderFont)font fontSize:(NSInteger)size;
-(LBParsedString*)parsedStringForMarkup:(NSString*)html;
-(NSAttributedString*)attributedStringForParsed:(LBParsedString *)parsed withFont:(ReaderFont)font fontSize:(NSInteger)size;

-(NSString*)boldFontName:(ReaderFont)font;
-(NSString*)italicFontName:(ReaderFont)font;
-(NSString*)normalFontName:(ReaderFont)font;
-(NSString*)humanFontName:(ReaderFont)font;
    

@end
