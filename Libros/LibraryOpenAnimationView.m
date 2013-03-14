//
//  LibraryOpenAnimationView.m
//  Libros
//
//  Created by Sean Hess on 3/13/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "LibraryOpenAnimationView.h"
#import "LibraryBookCoverCell.h"

@interface LibraryOpenAnimationView ()
@property (nonatomic, strong) UIImageView * imageView;
@end

@implementation LibraryOpenAnimationView

-(id)initWithImage:(UIImage*)coverImage frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageView = [[UIImageView alloc] initWithImage:coverImage];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.imageView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:self.imageView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
