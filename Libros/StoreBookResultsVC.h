//
//  StoreVC.h
//  Libros
//
//  Created by Sean Hess on 1/10/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoreFilterVC.h"

@interface StoreBookResultsVC : UITableViewController <NSFetchedResultsControllerDelegate, StoreFilterDelegate>

@property (strong, nonatomic) NSFetchRequest * fetchRequest;

@end
