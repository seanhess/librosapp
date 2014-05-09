//
//  IAPRestoreCommand.m
//  Libros
//
//  Created by Sean Hess on 5/21/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "IAPRestoreCommand.h"
#import <StoreKit/StoreKit.h>
#import "BookService.h"

@interface IAPRestoreCommand () <SKPaymentTransactionObserver>
@property (nonatomic, strong) void(^cb)(IAPRestoreCommand*);
@end

@implementation IAPRestoreCommand

-(void)restorePurchasesWithCb:(void(^)(IAPRestoreCommand*))cb {
    self.cb = cb;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    
    // convert productId back to bookId
    // Look up each one in the store by product id
    // or... you could get all of them at once
    // but there's no way to know when it is done, right?
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    NSMutableArray * bookIds = [NSMutableArray array];
    
    for (SKPaymentTransaction * transaction in transactions) {
        if(transaction.transactionState == SKPaymentTransactionStateRestored) {
            NSString * productId = transaction.originalTransaction.payment.productIdentifier;
            
            if ([productId isEqualToString:ALL_BOOKS_PRODUCT_ID])
                self.allBooks = YES;
            else
                [bookIds addObject:[[BookService shared] bookIdFromProductId:productId]];
        }
        
        else {
            NSLog(@"IGNORED %li", (long)transaction.transactionState);
        }
    }
    
    self.books = [[BookService shared] booksWithIds:bookIds];
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    self.cb(self);
}

- (void)dealloc {
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

@end
