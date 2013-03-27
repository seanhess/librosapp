//
//  ReaderFontVC2.h
//  Libros
//
//  Created by Sean Hess on 3/27/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ReaderVolumeDelegate
-(void)didSlideVolume:(CGFloat)value;
@end

@interface ReaderVolumeVC2 : UIViewController
@property (nonatomic) CGFloat value;
@property (nonatomic, weak) id<ReaderVolumeDelegate>delegate;
@end
