//
//  StoreBookCell.m
//  Libros
//
//  Created by Sean Hess on 1/29/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#define HORIZONTAL_ICON_SPACE 8

#import "StoreBookCell.h"
#import "Icons.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Covers.h"
#import "Appearance.h"
#import "BookService.h"

#define COVER_HEIGHT 66
#define COVER_PADDING_LEFT 7
#define COVER_WIDTH COVER_HEIGHT*COVER_HEIGHT_TO_WIDTH
#define COVER_PADDING_TOP 7
#define ICONS_LEFT COVER_WIDTH+COVER_PADDING_LEFT+10

@interface StoreBookCell ()
@property (nonatomic, strong) UIImageView * audioIconView;
@property (nonatomic, strong) UIImageView * textIconView;

@property (nonatomic, strong) UIImageView * coverImageView;
@property (nonatomic, strong) UIView * iconsView;

@property (nonatomic) CGRect audioFrame;
@property (nonatomic) CGRect textFrame;

@property (nonatomic, strong) UIProgressView * downloadProgress;

@end

@implementation StoreBookCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textIconView = [[UIImageView alloc] initWithImage:Icons.text];
        self.audioIconView = [[UIImageView alloc] initWithImage:Icons.audio];
        self.iconsView = [[UIView alloc] initWithFrame:CGRectMake(ICONS_LEFT, 50, 0, 0)];
        [self.iconsView addSubview:self.textIconView];
        [self.iconsView addSubview:self.audioIconView];
        [self.contentView addSubview:self.iconsView];
        
        self.audioFrame = self.audioIconView.frame;
        self.textFrame = self.textIconView.frame;
        
        self.selectedBackgroundView = Appearance.tableSelectedBackgroundView;
        
        self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(COVER_PADDING_LEFT, COVER_PADDING_TOP, COVER_WIDTH, COVER_HEIGHT)];
        [self.contentView addSubview:self.coverImageView];
        
        self.downloadProgress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        CGRect progressFrame = self.downloadProgress.frame;
        progressFrame.origin.x = self.coverImageView.frame.origin.x + 4;
        progressFrame.origin.y = self.coverImageView.frame.size.height - progressFrame.size.height + 2;
        progressFrame.size.width = COVER_WIDTH - 8;
        self.downloadProgress.frame = progressFrame;
        [self.contentView addSubview:self.downloadProgress];
    }
    return self;
}

- (void)setBook:(Book *)book {
    _book = book;
    
    self.textLabel.text = book.title;
    self.detailTextLabel.text = book.author;
    [self addTypeIcons:book];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    __weak StoreBookCell * cell = self;
    
    [self.coverImageView setImageWithURL:[NSURL URLWithString:self.book.imageUrl] placeholderImage:nil completed:^(UIImage * image, NSError*error, SDImageCacheType cacheType) {
        [cell setNeedsLayout];
    }];
    
    [self.book addObserver:self forKeyPath:BOOK_ATTRIBUTE_DOWNLOADED options:NSKeyValueObservingOptionNew context:nil];
    [self renderProgress];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:BOOK_ATTRIBUTE_DOWNLOADED]) {
        [self renderProgress];
    }
}

- (void)renderProgress {
    if (self.book.downloaded < 1.0 && self.book.downloaded > 0.0) {
        self.downloadProgress.hidden = NO;
        self.downloadProgress.progress = self.book.downloaded;
    }
    else {
        self.downloadProgress.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat offsetX = COVER_WIDTH + 7;
    CGFloat offsetY = -14;
    CGFloat padding = 10;
    CGFloat labelWidth = self.frame.size.width - (self.textLabel.frame.origin.x + offsetX + self.accessoryView.frame.size.width + padding);
    
    CGRect textLabelFrame = self.textLabel.frame;
    textLabelFrame.origin.x += offsetX;
    textLabelFrame.origin.y += offsetY;
    textLabelFrame.size.width = labelWidth;
    self.textLabel.frame = textLabelFrame;
    
    CGRect detailLabelFrame = self.detailTextLabel.frame;
    detailLabelFrame.origin.x += offsetX;
    detailLabelFrame.origin.y += offsetY;
    detailLabelFrame.size.width = labelWidth;
    self.detailTextLabel.frame = detailLabelFrame;
}

- (void)addTypeIcons:(Book*)book {
    if (book.audioFiles && book.textFiles) {
        self.textIconView.hidden = NO;
        self.audioIconView.hidden = NO;
        
        CGRect audioFrame = self.audioFrame;
        audioFrame.origin.y = roundf((self.textFrame.size.height - audioFrame.size.height)/2);
        
        CGRect textFrame = self.textFrame;
        textFrame.origin.x = audioFrame.size.width + HORIZONTAL_ICON_SPACE;
        
        self.textIconView.frame = textFrame;
        self.audioIconView.frame = audioFrame;
        CGRect frame = self.iconsView.frame;
        frame.size = CGSizeMake(textFrame.origin.x + textFrame.size.width, MAX(textFrame.size.height, audioFrame.size.height));
        self.iconsView.frame = frame;
    }
    
    else if (book.audioFiles) {
        self.audioIconView.frame = self.audioFrame;
        self.textIconView.hidden = YES;
        self.audioIconView.hidden = NO;
        CGRect iconsFrame = self.iconsView.frame;
        iconsFrame.size = self.audioFrame.size;
        self.iconsView.frame = iconsFrame;
    }
    
    else {
        self.textIconView.frame = self.textFrame;
        self.textIconView.hidden = NO;
        self.audioIconView.hidden = YES;
        CGRect iconsFrame = self.iconsView.frame;
        iconsFrame.size = self.textFrame.size;
        self.iconsView.frame = iconsFrame;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [self.book removeObserver:self forKeyPath:BOOK_ATTRIBUTE_DOWNLOADED];
}

@end
