//
//  StoreBookResultsFilterView.h
//  Libros
//
//  Created by Sean Hess on 2/7/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColoredButton.h"
#import "BookService.h"

@protocol StoreBookResultsFilterDelegate <NSObject>
-(void)didSelectFilter:(BookFilter)filter;
@end

@interface StoreBookResultsFilterView : UIView
@property (weak, nonatomic) id<StoreBookResultsFilterDelegate>delegate;
+(StoreBookResultsFilterView*)filterView;
- (void)renderSelectedSegment;
@end
