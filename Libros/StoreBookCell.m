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
    if (book.audioFilesValue && book.textFilesValue) {
        self.textIconView.hidden = NO;
        self.audioIconView.hidden = NO;
        
        CGRect audioFrame = self.audioFrame;
        audioFrame.origin.y = roundf((self.textFrame.size.height - audioFrame.size.height)/2);
        
        CGRect textFrame = self.textFrame;
        textFrame.origin.x = audioFrame.size.width + HORIZONTAL_ICON_SPACE;
        
        self.textIconView.frame = textFrame;
        self.audioIconView.frame = audioFrame;
        self.iconsView.frame = CGRectMake(0, 0, textFrame.origin.x + textFrame.size.width, MAX(textFrame.size.height, audioFrame.size.height));
    }
    
    else if (book.audioFilesValue) {
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

@end
