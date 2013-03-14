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
@property (nonatomic, strong) UIImageView * dropShadowImageView;
@end

@implementation LibraryBookCoverCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // self.backgroundColor = [UIColor redColor];
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 6, COVER_IMAGE_WIDTH, COVER_IMAGE_HEIGHT)];
//        self.imageView.contentMode = UIViewContentModeTopLeft;
        self.dropShadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"book-shadow.png"]];
        self.dropShadowImageView.contentMode = UIViewContentModeTopLeft;
        self.dropShadowImageView.frame = CGRectMake(-2, 0, self.dropShadowImageView.image.size.width, self.dropShadowImageView.image.size.height);
        
//        self.layer.shadowColor = UIColor.blackColor.CGColor;
//        self.layer.shadowOffset = CGSizeMake(-2, 0);
//        self.layer.shadowOpacity = 0.8;
//        self.layer.shadowRadius = 4.0;
        
        [self addSubview:self.dropShadowImageView];
        [self addSubview:self.imageView];
    }
    return self;
}

-(void)setBook:(Book *)book {
    _book = book;
    [self.imageView setImageWithURL:[NSURL URLWithString:self.book.imageUrl] placeholderImage:nil completed:nil];
}

-(UIImage*)cachedImage {
    return self.imageView.image;
}

-(CGRect)cachedImageFrame {
    return self.imageView.frame;
}

@end
