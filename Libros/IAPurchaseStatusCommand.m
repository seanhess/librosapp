//
//  IAPurchaseStatusCommand.m
//  Libros
//
//  Created by Sean Hess on 3/24/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

// NEVERMIND - it prompts for a password to get this to work, which is not ideal
// we'll just use the thing I did before

#import "IAPurchaseStatusCommand.h"

@interface IAPurchaseStatusCommand () <SKPaymentTransactionObserver>
@property (nonatomic, strong) void(^cb)(IAPurchaseStatusCommand*);
@property (nonatomic, strong) SKProduct * bookProduct;
@property (nonatomic, strong) SKProduct * allBooksProduct;
@end

@implementation IAPurchaseStatusCommand
- (void)loadPurchaseStatusForBookProduct:(SKProduct*)bookProduct allBooksProduct:(SKProduct*)allBooksProduct cb:(void(^)(IAPurchaseStatusCommand*))cb {
    self.bookProduct = bookProduct;
    self.allBooksProduct = allBooksProduct;
    self.isPurchasedAll = NO;
    self.isPurchasedBook = NO;
    self.cb = cb;
    
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    self.error = error;
    self.cb(self);
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    self.cb(self);
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction * transaction in transactions) {
        if (transaction.transactionState == SKPaymentTransactionStateRestored) {
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            NSString * productId = transaction.originalTransaction.payment.productIdentifier;
            if ([self.bookProduct.productIdentifier isEqualToString:productId])
                self.isPurchasedBook = YES;
            else if ([self.allBooksProduct.productIdentifier isEqualToString:productId])
                self.isPurchasedAll = YES;
        }
    }
}

@end
