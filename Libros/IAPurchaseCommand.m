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
            NSLog(@"PAYMENT COMPLETED");
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            self.completed = YES;
            [self done];
        }
        else if(transaction.transactionState == SKPaymentTransactionStateFailed) {
            NSLog(@"PAYMENT FAILED");
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            self.completed = NO;
            [self done];
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
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(void)error:(NSError*)error {
    self.error = error;
    [self done];
}

-(void)done {
    self.cb(self);
}

@end
