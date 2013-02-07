//
//  LibraryVC.h
//  Libros
//
//  Created by Sean Hess on 1/10/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@interface LibraryVC : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) Book * loadBook;

@end
