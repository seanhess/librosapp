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
#import "UserService.h"
#import "FileService.h"
#import "MBProgressHUD.h"
#import "LibraryVC.h"
#import "IAPurchaseCommand.h"
#import <StoreKit/StoreKit.h>
#import "Settings.h"
#import "MetricsService.h"
#import "Appearance.h"

// TODO should download the product details when this page loads to get the price
// because it will be different per-locale

@interface StoreDetailsVC () <IAPurchaseCommandDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet ColoredButton *buyButton;
@property (weak, nonatomic) IBOutlet ColoredButton *libraryButton;
@property (weak, nonatomic) IBOutlet ColoredButton *buyAllButton;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *formatsLabel;
@property (weak, nonatomic) IBOutlet HorizontalFlowView *iconsView;
@property (weak, nonatomic) IBOutlet UIImageView *audioIcon;
@property (weak, nonatomic) IBOutlet UIImageView *textIcon;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;

@property (strong, nonatomic) IAPurchaseCommand * purchaseCommand;

@property (strong, nonatomic) MBProgressHUD * hud;

@end

@implementation StoreDetailsVC

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.backgroundColor = Appearance.background;
    
    [MetricsService storeBookLoad:self.book];
    
    // any initialization of nib things needs to happen in here, not in initWithNibName! might not be there.
    self.iconsView.padding = 7;
    
    // We need to load the files for the book
    [[FileService shared] loadFilesForBook:self.book.bookId cb:^{}];
    
    self.titleLabel.text = self.book.title;
    self.authorLabel.text = [NSString stringWithFormat:@"%@", self.book.author];
    self.descriptionTextView.text = self.book.descriptionText;
    
    [self.coverImage setImageWithURL:[NSURL URLWithString:self.book.imageUrl] placeholderImage:nil];
    
    [self resizeContent];
    [self renderButtonAndDownload];
    
    [self.book addObserver:self forKeyPath:BookAttributes.downloaded options:NSKeyValueObservingOptionNew context:nil];
    [self.book addObserver:self forKeyPath:BookAttributes.purchased options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:BookAttributes.downloaded]) {
        self.hud.progress = self.book.downloadedValue;
        [self renderButtonAndDownload];
    }
    
    else if ([keyPath isEqualToString:BookAttributes.purchased]) {
        [self renderButtonAndDownload];
    }
}

- (void)renderButtonAndDownload {
    self.buyButton.enabled = YES;
    
    self.buyButton.style = ColoredButtonStyleGreen;
    NSString * buttonLabel = [NSString stringWithFormat:@"Buy for $%@", self.book.priceString];
    [self.buyButton setTitle:buttonLabel forState:UIControlStateNormal];
    
    self.libraryButton.style = ColoredButtonStyleGray;
    self.buyAllButton.style = ColoredButtonStyleBlue;
    NSString * allLabel = [NSString stringWithFormat:@"Unlock all books for $%@", @"4.99"];
    [self.buyAllButton setTitle:allLabel forState:UIControlStateNormal];
    
    if (!self.book.purchasedValue && !self.purchaseCommand) {
        self.buyButton.hidden = NO;
        self.buyAllButton.hidden = NO;
        self.libraryButton.hidden = YES;
    }
    
    else {
        self.buyButton.hidden = YES;
        self.buyAllButton.hidden = YES;
        self.libraryButton.hidden = NO;
        
        if (self.purchaseCommand) {
            [self.libraryButton setTitle:@"Purchasing" forState:UIControlStateNormal];
            self.libraryButton.enabled = NO;
        }
        
        // well, I should use a total bytes thing so it actually updates
        else if (self.book.downloadedValue < 1.0) {
            [self.libraryButton setTitle:@"Downloading" forState:UIControlStateNormal];
            self.libraryButton.enabled = NO;
            
            // only if it hasn't been displayed yet!
            if (!self.hud) {
                self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                self.hud.mode = MBProgressHUDModeDeterminate;
                self.hud.labelText = @"Downloading Book";
                self.hud.progress = self.book.downloadedValue;
            }
        }
        
        else {
            [self.libraryButton setTitle:@"View in Library" forState:UIControlStateNormal];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.hud = nil;
        }
    }
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
    if (self.book.audioFilesValue && self.book.textFilesValue) {
        self.textIcon.hidden = NO;
        self.audioIcon.hidden = NO;
        self.formatsLabel.text = @"Text and Audio";
    }
    
    else if (self.book.audioFilesValue) {
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
    formatsLabelFrame.origin.x = self.iconsView.frame.origin.x + self.iconsView.frame.size.width + 8;
    self.formatsLabel.frame = formatsLabelFrame;
}


- (IBAction)didTapBuy:(id)sender {
    
    if (self.book.purchased && self.book.downloadedValue == 1.0) {
        [self viewInLibrary];
    }
    
    else {
        [self purchaseBook];
    }
}

- (void)viewInLibrary {
    UINavigationController * nav = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"LibraryNav"];
    LibraryVC * library = (LibraryVC*)nav.topViewController;
    library.loadBook = self.book;
    nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)purchaseBook {
    [MetricsService storeBookBeginBuy:self.book];
    
    if (IAP_SKIP) {
        [self didCompletePurchase:self.book];
        return;
    }
    
    self.purchaseCommand = [IAPurchaseCommand new];
    [self.purchaseCommand runWithBook:self.book delegate:self];
    [self renderButtonAndDownload];
}

- (void)didErrorPurchase:(NSError *)error {
    self.purchaseCommand = nil;
    [self renderButtonAndDownload];
}

- (void)didCancelPurchase:(Book *)book {
    self.purchaseCommand = nil;
    [self renderButtonAndDownload];
}

- (void)didCompletePurchase:(Book *)book {
    [MetricsService storeBookFinishBuy:self.book];
    self.purchaseCommand = nil;
    [UserService.shared addBook:self.book];
    [self renderButtonAndDownload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc {
    [self.book removeObserver:self forKeyPath:BookAttributes.downloaded];
    [self.book removeObserver:self forKeyPath:BookAttributes.purchased];
}

@end
