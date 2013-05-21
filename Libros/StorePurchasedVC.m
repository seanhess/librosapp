//
//  StorePurchasedVC.m
//  Libros
//
//  Created by Sean Hess on 5/21/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "StorePurchasedVC.h"
#import "IAPRestoreCommand.h"
#import "UserService.h"
#import "BookService.h"

@interface StorePurchasedVC ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *libraryButton;
@property (strong, nonatomic) IAPRestoreCommand * restoreCommand;
@property (strong, nonatomic) ColoredButton * restoreButton;
@end

// I could automatically restore when they come to the tab
// that would be kind of cool. but naw, then they have to sign in
// just use a big button

@implementation StorePurchasedVC

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.title = NSLocalizedString(@"Purchased",nil);
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar-icon-purchases-selected"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar-icon-purchases"]];
    }
    return self;
}

- (void)viewDidLoad
{
    self.libraryButton.title = NSLocalizedString(@"Library",nil);
    
    self.fetchRequest = [[BookService shared] purchased];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    CGFloat padding = 8;
    UIView * restoreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    ColoredButton * restoreButton = [[ColoredButton alloc] initWithFrame:CGRectMake(padding, padding, restoreView.bounds.size.width - 2*padding, restoreView.bounds.size.height - padding*1.4)];
    restoreButton.style = ColoredButtonStyleGreen;
    restoreButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    restoreButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    [restoreButton setTitle:NSLocalizedString(@"Restore Purchases", nil) forState:UIControlStateNormal];
    [restoreButton addTarget:self action:@selector(didTapRestore:) forControlEvents:UIControlEventTouchUpInside];
    self.restoreButton = restoreButton;
    [restoreView addSubview:restoreButton];
    
    self.tableView.tableHeaderView = restoreView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapRestore:(id)sender {
    self.restoreCommand = [IAPRestoreCommand new];
    [self.restoreCommand restorePurchasesWithCb:^(IAPRestoreCommand* command) {
        if (command.allBooks)
            [UserService.shared purchasedAllBooks];
        
        for (Book * book in command.books)
            [[UserService shared] setHasPurchasedBook:book];
        
        self.restoreButton.style = ColoredButtonStyleGray;
        self.restoreButton.enabled = NO;
        [self.restoreButton setTitle:[NSString stringWithFormat:@"%i %@", command.books.count, NSLocalizedString(@"Books Restored", nil)] forState:UIControlStateNormal];
        [self reloadData];
    }];
}


@end
