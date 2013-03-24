//
//  IAPurchaseStatusCommand.h
//  Libros
//
//  Created by Sean Hess on 3/24/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Book.h"
#import <StoreKit/StoreKit.h>

@interface IAPurchaseStatusCommand : NSObject
@property (nonatomic) BOOL isPurchasedBook;
@property (nonatomic) BOOL isPurchasedAll;
@property (nonatomic, strong) NSError * error;
- (void)loadPurchaseStatusForBookProduct:(SKProduct*)bookProduct allBooksProduct:(SKProduct*)allBooksProduct cb:(void(^)(IAPurchaseStatusCommand*))cb;
@end
