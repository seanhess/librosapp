//
//  LBParsedString.m
//  Libros
//
//  Created by Sean Hess on 2/13/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "LBParsedString.h"
#import "NSArray+Functional.h"


@interface AttributeInfo : NSObject <NSCoding>
@property (nonatomic) LBParsedStringAttribute attribute;
@property (nonatomic) NSRange range;
@end

@implementation AttributeInfo


-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        NSValue * value = [decoder decodeObjectForKey:@"range"];
        NSRange range;
        [value getValue:&range];
        self.range = range;
        self.attribute = (LBParsedStringAttribute) [decoder decodeIntegerForKey:@"attribute"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:self.attribute forKey:@"attribute"];
    NSRange range = self.range;
    NSValue * value = [NSValue value:&range withObjCType:@encode(NSRange)];
    [coder encodeObject:value forKey:@"range"];
}

-(NSString*)description {
    return [NSString stringWithFormat:@"%@ attribute=%i range={%lu, %lu}", [super description], self.attribute, (unsigned long)self.range.location, (unsigned long)self.range.length];
}

@end




@interface LBParsedString ()

@property (nonatomic, strong) NSMutableArray * attributes;

@end

@implementation LBParsedString

-(id)initWithText:(NSString *)text {
    self = [super init];
    if (self) {
        self.text = text;
        self.attributes = [NSMutableArray array];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.text = [decoder decodeObjectForKey:@"text"];
        self.attributes = [decoder decodeObjectForKey:@"attributes"];
    }
    return self;
}

-(void)setAttribute:(LBParsedStringAttribute)attribute range:(NSRange)range {
    if (!self.attributes) self.attributes = [NSMutableArray array];
    
    AttributeInfo * info = [AttributeInfo new];
    info.attribute = attribute;
    info.range = range;
    [self.attributes addObject:info];
}

-(void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.text forKey:@"text"];
    [coder encodeObject:self.attributes forKey:@"attributes"];
}

-(void)forEachAttribute:(void (^)(LBParsedStringAttribute, NSRange))iterator {
    [self.attributes forEach:^(AttributeInfo*info) {
        iterator(info.attribute, info.range);
    }];
}

@end




