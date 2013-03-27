//
//  IAPClearCommand.h
//  Libros
//
//  Created by Sean Hess on 3/27/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

// Just empties the queue of garbage
// Run this well before you try to buy something to clean out nonsense

#import <Foundation/Foundation.h>

@interface IAPClearCommand : NSObject
-(void)clearOrphanPurchases;
-(void)deactivate;
@end
