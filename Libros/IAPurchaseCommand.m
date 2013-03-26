//
//  IAPService.m
//  Libros
//
//  Created by Sean Hess on 2/23/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "IAPurchaseCommand.h"
#import <StoreKit/StoreKit.h>

@interface IAPurchaseCommand () <SKPaymentTransactionObserver>
@property (nonatomic, strong) void(^cb)(IAPurchaseCommand*);
@end

@implementation IAPurchaseCommand

#pragma mark - SKProductsRequestDelegate

-(void)purchaseProduct:(SKProduct *)product cb:(void (^)(IAPurchaseCommand *))cb {
    self.product = product;
    self.cb = cb;
    self.completed = NO;
    self.purchasing = YES;
    NSLog(@"IAPurchaseCommand - purchase!");
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

//- (void)completeAllExistingTransactions {
//    NSLog(@"TRANSACTIONs? %i", [[SKPaymentQueue defaultQueue] transactions].count);
//    for (SKPaymentTransaction * transaction in [[SKPaymentQueue defaultQueue] transactions]) {
//        NSLog(@"TRANSACTION IN QUEUE %@", transaction);
//    }
//}

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
            NSLog(@"PAYMENT FAILED");
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            self.completed = NO;
            [self finishAndCallback];
        }
        else if(transaction.transactionState == SKPaymentTransactionStateRestored) {
            // just complete them and ignore
            NSLog(@"RESTORED");
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            // [self.delegate didCompletePurchase];
        }
        else {
            NSLog(@"PAYMENT %i", transaction.transactionState);
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
    self.purchasing = NO;
//    NSLog(@"IAPurchase Command - done");
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    self.cb(self);
}

@end
