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

@protocol IAPurchaseCommandDelegate <NSObject>
- (void)didCompletePurchase:(Book*)book;
@optional
- (void)didCancelPurchase:(Book*)book;
- (void)didErrorPurchase:(NSError*)error;
@end

@interface IAPurchaseCommand : NSObject

@property (nonatomic, strong) Book * book;
@property (nonatomic, weak) id<IAPurchaseCommandDelegate>delegate;

- (void)runWithBook:(Book*)book delegate:(id<IAPurchaseCommandDelegate>)delegate;

@end
