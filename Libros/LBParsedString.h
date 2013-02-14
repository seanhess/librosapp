//
//  LBParsedString.h
//  Libros
//
//  Created by Sean Hess on 2/13/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LBParsedStringAttributeNone = 0,
    LBParsedStringAttributeBold = 1,
    LBParsedStringAttributeItalic,
} LBParsedStringAttribute;

@interface LBParsedString : NSObject <NSCoding>

@property (nonatomic, strong) NSString * text;

-(id)initWithText:(NSString*)text;

-(void)setAttribute:(LBParsedStringAttribute)attribute range:(NSRange)range;
-(void)forEachAttribute:(void(^)(LBParsedStringAttribute, NSRange))iterator;

@end
