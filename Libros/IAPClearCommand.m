//
//  IAPClearCommand.m
//  Libros
//
//  Created by Sean Hess on 3/27/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "IAPClearCommand.h"
#import <StoreKit/StoreKit.h>

@interface IAPClearCommand () <SKPaymentTransactionObserver>

@end

@implementation IAPClearCommand

-(void)clearOrphanPurchases {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [self completeAllExistingTransactions];
}

- (void)completeAllExistingTransactions {
    for (SKPaymentTransaction * transaction in [[SKPaymentQueue defaultQueue] transactions]) {
        NSLog(@"IAPClearCommand: IN QUEUE %@", transaction);
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction* transaction in transactions) {
        if (transaction.transactionState == SKPaymentTransactionStateFailed || transaction.transactionState == SKPaymentTransactionStatePurchased || transaction.transactionState == SKPaymentTransactionStateRestored) {
            NSLog(@"IAPClearCommand: CLEARING %@", transaction);
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
        }
    }
}

// must be called before you actually try to purchase something
-(void)deactivate {
    NSLog(@"IAPClearCommand: deactivating");
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

-(void)dealloc {
    [self deactivate];
}

@end
