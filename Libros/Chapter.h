//
//  Chapter.h
//  Libros
//
//  Created by Sean Hess on 3/25/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"

@interface Chapter : NSObject
@property (nonatomic, strong) File * textFile;
@property (nonatomic, strong) File * audioFile;
@property (nonatomic, strong) NSString * name;
@end
