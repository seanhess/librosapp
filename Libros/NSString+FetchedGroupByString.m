//
//  NSString+FetchedGroupByString.m
//  Libros
//
//  Created by Sean Hess on 2/6/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "NSString+FetchedGroupByString.h"

@implementation NSString (FetchedGroupByString)
- (NSString *)stringGroupByFirstInitial {
    if (!self.length || self.length == 1)
        return self;
    return [[self substringToIndex:1] lowercaseString];
}
@end
