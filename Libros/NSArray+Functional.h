//
//  NSArray+Functional.h
//  Libros
//
//  Created by Sean Hess on 1/29/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Functional)

-(NSArray*)filteredArrayUsingBlock:(BOOL(^)(id))block;

@end
