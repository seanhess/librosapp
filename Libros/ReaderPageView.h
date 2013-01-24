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

@interface ReaderPageView : UIView

@property (nonatomic) CGFloat frameXOffset;
@property (nonatomic) CGFloat frameYOffset;

-(NSInteger)makeFrame:(id)framesetter location:(NSInteger)location;
-(void)renderFrame:(id)frame;

@end
