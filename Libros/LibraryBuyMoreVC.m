//
//  LibararyBuyMoreVC.m
//  Libros
//
//  Created by Sean Hess on 3/28/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "LibraryBuyMoreVC.h"
#import <QuartzCore/QuartzCore.h>

@interface LibraryBuyMoreVC ()
@property (weak, nonatomic) IBOutlet UITextView *detailText;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation LibraryBuyMoreVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.label.text = NSLocalizedString(@"More Books", nil);
    self.detailText.text = NSLocalizedString(@"Visit Store", nil);
    
    // Do any additional setup after loading the view from its nib.
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
    [self.view addGestureRecognizer:tap];
}

-(void)pretendToBeButton {
    self.label.alpha = 0.0;
    self.detailText.alpha = 0.0;
    self.view.layer.cornerRadius = 6.0;
}

- (void)didTap:(id)sender {
    [self.delegate didTapBuyMore];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
