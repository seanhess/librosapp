//
//  Chapter.m
//  Libros
//
//  Created by Sean Hess on 3/25/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "Chapter.h"
#import "FileService.h"

@implementation Chapter
-(NSString*)description {
    return [NSString stringWithFormat:@"<Chapter text:%@ audio:%@ name:%@", self.textFile.ext, self.audioFile.ext, self.name];
}
@end
