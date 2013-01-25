//
//  ReaderPageView.h
//  Libros
//
//  Created by Sean Hess on 1/24/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.

//  Displays a single column of text on the page
//  Just set its attributed string

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "ReaderFramesetter.h"

@interface ReaderPageView : UIView

@property (nonatomic) NSInteger chapter;
@property (nonatomic) NSInteger page;

// will only render if it CHANGES
-(void)setFrameFromCache:(ReaderFramesetter*)cache chapter:(NSInteger)chapter page:(NSInteger)page;

@end
