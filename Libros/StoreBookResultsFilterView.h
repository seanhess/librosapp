//
//  StoreBookResultsFilterView.h
//  Libros
//
//  Created by Sean Hess on 2/7/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColoredButton.h"

@protocol StoreBookResultsFilterDelegate <NSObject>
-(void)didTapFilterButton;
@end

@interface StoreBookResultsFilterView : UIView
@property (weak, nonatomic) id<StoreBookResultsFilterDelegate>delegate;
-(void)setButtonTitle:(NSString*)title;
+(StoreBookResultsFilterView*)filterView;
@end
