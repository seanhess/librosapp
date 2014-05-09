//
//  IAPService.m
//  Libros
//
//  Created by Sean Hess on 2/23/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "IAPurchaseCommand.h"
#import <StoreKit/StoreKit.h>

#define ERROR_CANNOT_CONNECT_ITUNES_STORE 2

@interface IAPurchaseCommand () <SKPaymentTransactionObserver>
@property (nonatomic, strong) void(^cb)(IAPurchaseCommand*);
@end

// Add a listener that clears everything out ahead of time

@implementation IAPurchaseCommand

#pragma mark - SKProductsRequestDelegate

-(void)purchaseProduct:(SKProduct *)product cb:(void (^)(IAPurchaseCommand *))cb {
    self.product = product;
    self.cb = cb;
    self.completed = NO;
    NSLog(@"IAPurchaseCommand - purchase!");
    
//    [self completeAllExistingTransactions];
    
    NSLog(@"ADDING OVERSERVER %lu", (unsigned long)[[SKPaymentQueue defaultQueue] transactions].count);
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    // I want to know when the queue is EMPTY
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions {
    NSLog(@"Removed Transactions");
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
            NSLog(@"PAYMENT COMPLETED %@", transaction);
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            self.completed = YES;
            [self finishAndCallback];
        }
        else if(transaction.transactionState == SKPaymentTransactionStateFailed) {
            NSLog(@"PAYMENT FAILED %@", transaction.error);
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            self.completed = NO;
//            if (transaction.error.code != ERROR_CANNOT_CONNECT_ITUNES_STORE)
//                [self finishAndCallback];
            [self finishAndCallback];
        }
        else if(transaction.transactionState == SKPaymentTransactionStateRestored) {
            // just complete them and ignore
            NSLog(@"RESTORED");
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            // [self.delegate didCompletePurchase];
        }
        else {
            NSLog(@"PAYMENT %li", (long)transaction.transactionState);
        }
    };
}

- (void)dealloc {
//    NSLog(@"IAPurchaseCommand - dealloc");
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(void)error:(NSError*)error {
//    NSLog(@"IAPurchase Command - ERROR %@", error);
    self.error = error;
    [self finishAndCallback];
}

-(void)finishAndCallback {
//    NSLog(@"IAPurchase Command - done");
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    self.cb(self);
}

@end


