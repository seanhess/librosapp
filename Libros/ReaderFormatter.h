//
//  ReaderFormatter.h
//  Libros
//
//  Created by Sean Hess on 1/25/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReaderFormatter : NSObject

@property (strong, nonatomic) NSArray * files;

-(NSAttributedString*)textForChapter:(NSInteger)chapter;
    
@end
