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
#import "Covers.h"
#import "BookService.h"

@interface LibraryBookCoverCell ()
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UIImageView * dropShadowImageView;
@property (nonatomic, strong) UIProgressView * downloadProgress;
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
        
        
        self.downloadProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        CGRect progressFrame = self.downloadProgress.frame;
        progressFrame.origin.x = self.imageView.frame.origin.x + 4;
        progressFrame.origin.y = self.imageView.frame.size.height - progressFrame.size.height;
        progressFrame.size.width = COVER_IMAGE_WIDTH - 8;
        self.downloadProgress.frame = progressFrame;
        [self addSubview:self.downloadProgress];
    }
    return self;
}

-(void)setBook:(Book *)book {
    _book = book;
    [self.imageView setImageWithURL:[NSURL URLWithString:self.book.imageUrl] placeholderImage:nil completed:nil];
    
    [self.book addObserver:self forKeyPath:BOOK_ATTRIBUTE_DOWNLOADED options:NSKeyValueObservingOptionNew context:nil];
    
    [self renderProgress];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:BOOK_ATTRIBUTE_DOWNLOADED]) {
        [self renderProgress];
    }
}

- (void)renderProgress {
    self.downloadProgress.hidden = (self.book.downloaded == 1.0);
    self.downloadProgress.progress = self.book.downloaded;
}

-(UIImage*)cachedImage {
    return self.imageView.image;
}

-(CGRect)cachedImageFrame {
    return self.imageView.frame;
}

- (void)dealloc {
    [self.book removeObserver:self forKeyPath:BOOK_ATTRIBUTE_DOWNLOADED];
}

@end
