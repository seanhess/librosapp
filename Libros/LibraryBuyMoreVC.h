//
//  LibararyBuyMoreVC.h
//  Libros
//
//  Created by Sean Hess on 3/28/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LibraryBuyMoreDelegate
-(void)didTapBuyMore;
@end

@interface LibraryBuyMoreVC : UIViewController
@property (nonatomic, weak) id<LibraryBuyMoreDelegate>delegate;
-(void)pretendToBeButton;
@end
