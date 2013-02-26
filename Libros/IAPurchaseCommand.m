//
//  IAPService.m
//  Libros
//
//  Created by Sean Hess on 2/23/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "IAPurchaseCommand.h"
#import <StoreKit/StoreKit.h>

@interface IAPurchaseCommand () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@property (nonatomic, strong) SKProductsRequest * request;
@end

@implementation IAPurchaseCommand

#pragma mark - SKProductsRequestDelegate

-(void)runWithBook:(Book *)book delegate:(id<IAPurchaseCommandDelegate>)delegate {
    self.delegate = delegate;
    self.book = book;
    [self run];
}

- (void)run {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    NSSet * ids = [NSSet setWithArray:@[self.book.productId]];
    self.request = [[SKProductsRequest alloc] initWithProductIdentifiers:ids];
    self.request.delegate = self;
    [self.request start];
}

//
// call this before making a purchase
//
- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSLog(@"Loaded list of products...");
    NSArray * skProducts = response.products;
    
    if (skProducts.count != 1) {
        if ([self.delegate respondsToSelector:@selector(didErrorPurchase:)])
            [self.delegate didErrorPurchase:[NSError errorWithDomain:@"Could not find product" code:0 userInfo:nil]];
        return;
    }
    
    SKProduct * product = skProducts[0];
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
//    NSLog(@"Found product: %@ %@ %@ %0.2f",
//          product.productIdentifier,
//          product.localizedTitle,
//          product.localizedDescription,
//          product.price.floatValue);
    
}
 
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(didErrorPurchase:)])
        [self.delegate didErrorPurchase:error];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            NSLog(@"PURCHASED");
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            [self.delegate didCompletePurchase:self.book];
        }
        else if(transaction.transactionState == SKPaymentTransactionStateFailed) {
            NSLog(@"FAILED");
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            if ([self.delegate respondsToSelector:@selector(didCancelPurchase:)])
                [self.delegate didCancelPurchase:self.book];
        }
        else if(transaction.transactionState == SKPaymentTransactionStateRestored) {
            NSLog(@"RESTORED");
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            [self.delegate didCompletePurchase:self.book];
        }
        else {
            NSLog(@"payment???");
        }
    };
}

- (void)dealloc {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

@end
