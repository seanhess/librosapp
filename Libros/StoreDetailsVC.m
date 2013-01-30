//
//  StoreDetailsVC.m
//  Libros
//
//  Created by Sean Hess on 1/30/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "StoreDetailsVC.h"
#import "ColoredButton.h"
#import "HorizontalFlowView.h"
#import "Icons.h"

@interface StoreDetailsVC ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet ColoredButton *buyButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *formatsLabel;
@property (weak, nonatomic) IBOutlet HorizontalFlowView *iconsView;
@property (weak, nonatomic) IBOutlet UIImageView *audioIcon;
@property (weak, nonatomic) IBOutlet UIImageView *textIcon;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation StoreDetailsVC

- (void)viewWillAppear:(BOOL)animated {
//    self.title = self.book.title;
    self.buyButton.style = ColoredButtonStyleGreen;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // any initialization of nib things needs to happen in here, not in initWithNibName! might not be there.
    self.iconsView.padding = 5;
    
    self.titleLabel.text = self.book.title;
    self.authorLabel.text = [NSString stringWithFormat:@"%@", self.book.author];
    self.descriptionTextView.text = self.book.descriptionText;
    [self resizeContent];
    
    NSString * buttonLabel = [NSString stringWithFormat:@"Buy for $%@", self.book.priceString];
    [self.buyButton setTitle:buttonLabel forState:UIControlStateNormal];
    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self resizeContent];
}

-(void)resizeContent {
    CGRect descriptionFrame = self.descriptionTextView.frame;
    descriptionFrame.size.height = self.descriptionTextView.contentSize.height;
    self.descriptionTextView.frame = descriptionFrame;
    
    self.scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.descriptionTextView.frame.origin.y + self.descriptionTextView.frame.size.height);
}

-(void)viewDidLayoutSubviews {
    [self setFormats];
}

- (void)setFormats {
    if (self.book.hasAudioValue && self.book.hasTextValue) {
        self.textIcon.hidden = NO;
        self.audioIcon.hidden = NO;
        self.formatsLabel.text = @"Text and Audio";
    }
    
    else if (self.book.hasAudioValue) {
        self.textIcon.hidden = YES;
        self.audioIcon.hidden = NO;
        self.formatsLabel.text = @"Audiobook";
    }
    
    else {
        self.textIcon.hidden = NO;
        self.audioIcon.hidden = YES;
        self.formatsLabel.text = @"Text";
    }
    
    [self.iconsView flow];
    
    CGRect formatsLabelFrame = self.formatsLabel.frame;
    formatsLabelFrame.origin.x = self.iconsView.frame.origin.x + self.iconsView.frame.size.width + 5;
    self.formatsLabel.frame = formatsLabelFrame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
