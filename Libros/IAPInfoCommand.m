//
//  IAPInfoCommand.m
//  Libros
//
//  Created by Sean Hess on 3/24/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "IAPInfoCommand.h"
#import "NSArray+Functional.h"


#define ALL_BOOKS_PRODUCT_ID @"libros_all"

@interface IAPInfoCommand () <SKProductsRequestDelegate>
@property (nonatomic, strong) NSString * productId;
@property (nonatomic, strong) SKProductsRequest * request;
@property (nonatomic, strong) void(^cb)(IAPInfoCommand*);
@end

@implementation IAPInfoCommand

- (void)loadInfoForBook:(Book*)book cb:(void(^)(IAPInfoCommand*))cb {
    self.productId = book.productId;
    self.cb = cb;
    
    NSSet * ids = [NSSet setWithArray:@[self.productId, ALL_BOOKS_PRODUCT_ID]];
    self.request = [[SKProductsRequest alloc] initWithProductIdentifiers:ids];
    self.request.delegate = self;
    [self.request start];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    [self error:error];
}


-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray * skProducts = response.products;
    
    self.bookProduct = [skProducts find:^(SKProduct* product) {
        return [product.productIdentifier isEqualToString:self.productId];
    }];
    
    self.allBooksProduct = [skProducts find:^(SKProduct* product) {
        return [product.productIdentifier isEqualToString:ALL_BOOKS_PRODUCT_ID];
    }];
    
    if (!self.bookProduct || !self.allBooksProduct) {
        [self error:[NSError errorWithDomain:@"Could not find product" code:0 userInfo:nil]];
        return;
    }
    
    [self done];
}

-(void)error:(NSError*)error {
    self.error = error;
    [self done];
}

-(void)done {
    self.cb(self);
}

@end
