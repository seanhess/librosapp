//
//  NSArray+Functional.m
//  Libros
//
//  Created by Sean Hess on 1/29/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "NSArray+Functional.h"

@implementation NSArray (Functional)

-(NSArray *)filteredArrayUsingBlock:(BOOL(^)(id))match {
    NSPredicate * predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary * bindings) {
        return match(evaluatedObject);
    }];
    
    return [self filteredArrayUsingPredicate:predicate];
}

@end
