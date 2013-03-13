//
//  LibraryBookCoverCell.m
//  Libros
//
//  Created by Sean Hess on 2/22/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "LibraryBookCoverCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <QuartzCore/QuartzCore.h>

@interface LibraryBookCoverCell ()
@property (nonatomic, strong) UIImageView * imageView;
@end

@implementation LibraryBookCoverCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.layer.shadowColor = UIColor.blackColor.CGColor;
        self.layer.shadowOffset = CGSizeMake(-2, 0);
        self.layer.shadowOpacity = 0.8;
        self.layer.shadowRadius = 4.0;
        [self addSubview:self.imageView];
    }
    return self;
}

-(void)setBook:(Book *)book {
    _book = book;
    [self.imageView setImageWithURL:[NSURL URLWithString:self.book.imageUrl] placeholderImage:nil completed:nil];
}

@end
