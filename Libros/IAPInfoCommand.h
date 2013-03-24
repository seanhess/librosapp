//
//  IAPInfoCommand.h
//  Libros
//
//  Created by Sean Hess on 3/24/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"
#import <StoreKit/StoreKit.h>

@interface IAPInfoCommand : NSObject
@property SKProduct * bookProduct;
@property SKProduct * allBooksProduct;
@property NSError * error;
- (void)loadInfoForBook:(Book*)book cb:(void(^)(IAPInfoCommand*))cb;
@end
