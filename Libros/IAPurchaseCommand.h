//
//  IAPService.h
//  Libros
//
//  Created by Sean Hess on 2/23/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "Book.h"

@interface IAPurchaseCommand : NSObject
@property (nonatomic, strong) SKProduct * product;
@property (nonatomic, strong) NSError * error;
@property (nonatomic) BOOL completed;
- (void)purchaseProduct:(SKProduct*)product cb:(void(^)(IAPurchaseCommand*))cb;
@end
