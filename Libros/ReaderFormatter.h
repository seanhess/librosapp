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

@interface ReaderFormatter : NSObject

-(NSAttributedString*)textForFile:(File*)file;
-(LBParsedString*)parsedStringForMarkup:(NSString*)html;
-(NSAttributedString*)attributedStringForParsed:(LBParsedString *)parsed;

@end
