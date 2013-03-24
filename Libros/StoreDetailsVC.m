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
#import "BookService.h"
#import "LibraryVC.h"
#import "IAPurchaseCommand.h"
#import <StoreKit/StoreKit.h>
#import "Settings.h"
#import "MetricsService.h"
#import "Appearance.h"
#import <QuartzCore/QuartzCore.h>
#import "IAPInfoCommand.h"
#import "IAPurchaseStatusCommand.h"

// TODO should download the product details when this page loads to get the price
// because it will be different per-locale

@interface StoreDetailsVC ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet ColoredButton *buyButton;
@property (weak, nonatomic) IBOutlet ColoredButton *libraryButton;
@property (weak, nonatomic) IBOutlet ColoredButton *buyAllButton;

@property (weak, nonatomic) IBOutlet UILabel *formatsLabel;
@property (weak, nonatomic) IBOutlet HorizontalFlowView *iconsView;
@property (weak, nonatomic) IBOutlet UIImageView *audioIcon;
@property (weak, nonatomic) IBOutlet UIImageView *textIcon;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *coverImage;
@property (weak, nonatomic) IBOutlet UIView *downloadProgressBackground;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (strong, nonatomic) IAPurchaseCommand * purchaseCommand;
@property (strong, nonatomic) IAPInfoCommand * infoCommand;

@property (strong, nonatomic) SKProduct * bookProduct;
@property (strong, nonatomic) SKProduct * allBooksProduct;

// STEP 1, load the purchase information for the two products, get the prices, etc
// get the two SKPayment objects (each one associated with each button)

// STEP 2, if they pay, then run the purchase with a payment

@end

@implementation StoreDetailsVC

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.buyButton.style = ColoredButtonStyleGreen;
    self.libraryButton.style = ColoredButtonStyleGray;
    self.buyAllButton.style = ColoredButtonStyleBlue;
    
    self.scrollView.backgroundColor = Appearance.background;
    self.downloadProgressBackground.layer.cornerRadius = 5;
    self.downloadProgressBackground.userInteractionEnabled = NO;
    
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
    
    
    self.infoCommand = [IAPInfoCommand new];
    [self.infoCommand loadInfoForBook:self.book cb:^(IAPInfoCommand* info) {
        self.bookProduct = info.bookProduct;
        self.allBooksProduct = info.allBooksProduct;
        [self renderButtonAndDownload];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:BookAttributes.downloaded]) {
        [self setDownloadProgressValue:self.book.downloadedValue];
        [self renderButtonAndDownload];
    }
    
    else if ([keyPath isEqualToString:BookAttributes.purchased]) {
        [self renderButtonAndDownload];
    }
}

- (void)renderButtonAndDownload {
    BOOL alreadyPurchased = [[UserService shared] hasPurchasedBook:self.book];
    
    // Defaults = what you see on first load
    self.buyButton.hidden = NO;
    self.buyAllButton.hidden = NO;
    self.libraryButton.hidden = YES;
    self.downloadProgressBackground.hidden = YES;
    
    // States:
    // not purchased, not downloaded, not downloading
    // YES purchased, not downloaded
    // downloading
    // downloaded
    
    if (!alreadyPurchased && !self.isPurchasing) {
        if (self.bookProduct) {
            NSString* bookPriceString = [NSNumberFormatter localizedStringFromNumber:self.bookProduct.price numberStyle:NSNumberFormatterCurrencyStyle];
            [self.buyButton setTitle:[NSString stringWithFormat:@"Buy for %@", bookPriceString] forState:UIControlStateNormal];
            NSString* allPriceString = [NSNumberFormatter localizedStringFromNumber:self.allBooksProduct.price numberStyle:NSNumberFormatterCurrencyStyle];
            [self.buyAllButton setTitle:[NSString stringWithFormat:@"Buy All Books for %@", allPriceString] forState:UIControlStateNormal];
        }
        
        else {
            [self.buyButton setTitle:@"Buy" forState:UIControlStateNormal];
            [self.buyAllButton setTitle:@"Buy all Books" forState:UIControlStateNormal];
        }
    }
    
    else if (alreadyPurchased && !self.isPurchasing && !self.book.isDownloading && !self.book.isDownloadComplete) {
        self.buyAllButton.hidden = YES;
        [self.buyButton setTitle:@"Download Free" forState:UIControlStateNormal];
    }
    
    // these all use the library button
    else {
        
        self.buyButton.hidden = YES;
        self.buyAllButton.hidden = YES;
        self.libraryButton.hidden = NO;
        self.downloadProgressBackground.hidden = YES;
        
        if (self.isPurchasing) {
            [self.libraryButton setTitle:@"Purchasing" forState:UIControlStateNormal];
            self.libraryButton.enabled = NO;
        }
        
        else if (self.book.isDownloading) {
            [self.libraryButton setTitle:@"Downloading" forState:UIControlStateNormal];
            self.libraryButton.enabled = NO;
            self.downloadProgressBackground.hidden = NO;
            [self setDownloadProgressValue:self.book.downloadedValue];
        }
        
        else {
            self.downloadProgressBackground.hidden = NO;
            [self setDownloadProgressValue:self.book.downloadedValue];
            self.libraryButton.enabled = YES;
            [self.libraryButton setTitle:@"View in Library" forState:UIControlStateNormal];
        }
    }
}

-(BOOL)isPurchasing {
    return (self.purchaseCommand != nil);
}

-(void)setDownloadProgressValue:(float)value {
    CGRect frame = self.downloadProgressBackground.frame;
    frame.size.width = (self.libraryButton.frame.size.width) * value;
    self.downloadProgressBackground.frame = frame;
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
    BOOL alreadyPurchased = [[UserService shared] hasPurchasedBook:self.book];
             
    if (alreadyPurchased && self.book.isDownloadComplete) {
        [self viewInLibrary];
    }
    
    else if (alreadyPurchased) {
        [UserService.shared addBook:self.book];
        [self renderButtonAndDownload];
    }
             
    else {
        [self purchaseBook];
    }
}

- (IBAction)didTapBuyAll:(id)sender {
    [self purchaseAll];
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
    
    self.purchaseCommand = [IAPurchaseCommand new];
    [self.purchaseCommand purchaseProduct:self.bookProduct cb:^(IAPurchaseCommand*purchase) {
        if (purchase.completed) [self completePurchase];
        else [self cancelPurchase];
    }];
    [self renderButtonAndDownload];
}

- (void)purchaseAll {
    self.purchaseCommand = [IAPurchaseCommand new];

    [self.purchaseCommand purchaseProduct:self.allBooksProduct cb:^(IAPurchaseCommand*purchase) {
        if (purchase.completed) {
            [UserService.shared purchasedAllBooks];
            [self completePurchase];
        }
        else [self cancelPurchase];
    }];
    [self renderButtonAndDownload];
}

- (void)cancelPurchase {
    self.purchaseCommand = nil;
    [self renderButtonAndDownload];
}

- (void)completePurchase {
    [MetricsService storeBookFinishBuy:self.book];
    [UserService.shared addBook:self.book];
    self.purchaseCommand = nil;
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
