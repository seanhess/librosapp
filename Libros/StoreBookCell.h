//
//  StoreBookCell.h
//  Libros
//
//  Created by Sean Hess on 1/29/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

#define STORE_BOOK_CELL_HEIGHT 81;

@interface StoreBookCell : UITableViewCell

@property (strong, nonatomic) Book * book;


@end
