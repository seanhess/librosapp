//
//  UserService.h
//  Libros
//
//  Created by Sean Hess on 1/11/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"
#import "User.h"

@interface UserService : NSObject

@property (nonatomic, strong) User * main;

+(UserService*)shared;
-(User*)main;
-(void)addBook:(Book*)book;

@end
