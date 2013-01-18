//
//  ReaderVCViewController.m
//  Libros
//
//  Created by Sean Hess on 1/18/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "ReaderVC.h"
#import "BookService.h"
#import "FileService.h"

@interface ReaderVC ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ReaderVC

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
    
    // Assume book has been set by now
    self.title = self.book.title;
    
    // Load chapter one!
    FileService * fs = [FileService shared];
    NSArray * files = [fs byBookId:self.book.bookId];
    NSLog(@"bookId=%@ files=%@", self.book.bookId, files);
    self.textView.text = [fs readAsText:files[0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
