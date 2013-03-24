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

#define ALL_BOOKS_PRODUCT_ID @"libros_all"

@protocol IAPurchaseCommandDelegate <NSObject>
- (void)didCompletePurchase;
@optional
- (void)didCancelPurchase;
- (void)didErrorPurchase:(NSError*)error;
@end

@interface IAPurchaseCommand : NSObject

@property (nonatomic, strong) NSString * productId;
@property (nonatomic, weak) id<IAPurchaseCommandDelegate>delegate;

@property (nonatomic) BOOL isAllBooksPurchase;

- (void)runWithBook:(Book*)book delegate:(id<IAPurchaseCommandDelegate>)delegate;
- (void)runForAllBooksWithDelegate:(id<IAPurchaseCommandDelegate>)delegate;

@end
