//
//  ReaderFontVC.m
//  Libros
//
//  Created by Sean Hess on 2/28/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "ReaderFontVC.h"

#define MIN_SIZE 10
#define DEF_SIZE 18
#define MAX_SIZE 32

#define FONT_SIZE_KEY @"fontSize"

@interface ReaderFontVC ()
@end

@implementation ReaderFontVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.currentSize = [[NSUserDefaults standardUserDefaults] integerForKey:FONT_SIZE_KEY];
        if (!self.currentSize) self.currentSize = DEF_SIZE;
        self.currentFace = ReaderFontPalatino;
    }
    return self;
}

// does NOT get called if you just create it
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)decreaseFontSize:(id)sender {
    self.currentSize = [self stepSizeDown:self.currentSize];
    [[NSUserDefaults standardUserDefaults] setInteger:self.currentSize forKey:FONT_SIZE_KEY];
    [self.delegate didChangeFont];
}

- (IBAction)increaseFontSize:(id)sender {
    self.currentSize = [self stepSizeUp:self.currentSize];
    [[NSUserDefaults standardUserDefaults] setInteger:self.currentSize forKey:FONT_SIZE_KEY];
    [self.delegate didChangeFont];
}

- (NSInteger)stepSizeUp:(NSInteger)size {
    NSInteger newSize = size + 2;
    if (newSize > MAX_SIZE) return MAX_SIZE;
    return newSize;
}

- (NSInteger)stepSizeDown:(NSInteger)size {
    NSInteger newSize = size - 2;
    if (newSize < MIN_SIZE) return MIN_SIZE;
    return newSize;
}

@end
