//
//  ReaderFontVC.h
//  Libros
//
//  Created by Sean Hess on 2/28/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderFormatter.h"

@protocol ReaderFontDelegate
-(void)didChangeFont;
@end

@interface ReaderFontVC : UIViewController
@property (nonatomic, weak) id<ReaderFontDelegate>delegate;
@property (nonatomic) NSInteger currentSize;
@property (nonatomic) ReaderFont currentFace;
@end
