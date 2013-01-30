//
//  StoreBookCell.m
//  Libros
//
//  Created by Sean Hess on 1/29/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#define HORIZONTAL_ICON_SPACE 8

#import "StoreBookCell.h"

@interface StoreBookCell ()
@property (nonatomic, strong) UIImageView * audioIconView;
@property (nonatomic, strong) UIImageView * textIconView;
@property (nonatomic, strong) UIImageView * bothIconView;

@property (nonatomic) CGRect audioFrame;
@property (nonatomic) CGRect textFrame;
@end

@implementation StoreBookCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"179-notepad.png"]];
        self.audioIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"120-headphones.png"]];
        self.accessoryView = [UIView new];
        [self.accessoryView addSubview:self.textIconView];
        [self.accessoryView addSubview:self.audioIconView];
        
        self.audioFrame = self.audioIconView.frame;
        self.textFrame = self.textIconView.frame;
    }
    return self;
}

- (void)setBook:(Book *)book {
    _book = book;
    
    self.textLabel.text = book.title;
    self.detailTextLabel.text = book.author;
    self.accessoryView = [self addTypeIcons:book];
}

- (UIView*)addTypeIcons:(Book*)book {
    if (book.hasAudioValue && book.hasTextValue) {
        self.textIconView.hidden = NO;
        self.audioIconView.hidden = NO;
        
        CGRect audioFrame = self.audioFrame;
        audioFrame.origin.y = roundf((self.textFrame.size.height - audioFrame.size.height)/2);
        
        CGRect textFrame = self.textFrame;
        textFrame.origin.x = audioFrame.size.width + HORIZONTAL_ICON_SPACE;
        
        self.textIconView.frame = textFrame;
        self.audioIconView.frame = audioFrame;
        self.accessoryView.frame = CGRectMake(0, 0, textFrame.origin.x + textFrame.size.width, MAX(textFrame.size.height, audioFrame.size.height));
    }
    
    else if (book.hasAudioValue) {
        self.audioIconView.frame = self.audioFrame;
        self.accessoryView.frame = self.audioFrame;
        self.textIconView.hidden = YES;
        self.audioIconView.hidden = NO;
    }
    
    else {
        self.textIconView.frame = self.textFrame;
        self.accessoryView.frame = self.textFrame;
        self.textIconView.hidden = NO;
        self.audioIconView.hidden = YES;
    }
    
    return self.accessoryView;
}

//-(CGRect)leftIconFrame {
//    return
//}
//                

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
