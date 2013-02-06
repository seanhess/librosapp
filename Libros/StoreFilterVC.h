//
//  StoreFilterVC.h
//  Libros
//
//  Created by Sean Hess on 2/6/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"


@protocol StoreFilterDelegate <NSObject>
-(void)didSelectFilter:(BookFilter)filter;
@end

@interface StoreFilterVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<StoreFilterDelegate> delegate;
@property (nonatomic) BookFilter filter;

@end
