//
//  AuthorService.h
//  Libros
//
//  Created by Sean Hess on 2/1/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthorService : NSObject

+(AuthorService*)shared;
-(void)load;

-(NSFetchRequest*)allAuthors;
-(NSFetchRequest*)booksByAuthor:(NSString*)genre;
-(NSPredicate*)searchForText:(NSString*)text;

@end
