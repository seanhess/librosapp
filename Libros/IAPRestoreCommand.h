//
//  IAPRestoreCommand.h
//  Libros
//
//  Created by Sean Hess on 5/21/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IAPRestoreCommand : NSObject
@property (nonatomic, strong) NSError * error;
@property (nonatomic, strong) NSArray * books;
@property (nonatomic) BOOL allBooks;
-(void)restorePurchasesWithCb:(void(^)(IAPRestoreCommand*))cb;
@end
