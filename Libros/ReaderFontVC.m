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
#define FONT_FACE_KEY @"fontFace"

@interface ReaderFontVC () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *faceButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ReaderFontVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.currentSize = [[NSUserDefaults standardUserDefaults] integerForKey:FONT_SIZE_KEY];
        if (!self.currentSize) self.currentSize = DEF_SIZE;
        
        self.currentFace = [[NSUserDefaults standardUserDefaults] integerForKey:FONT_FACE_KEY];
        if (!self.currentFace) self.currentFace = ReaderFontPalatino;
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

- (void)viewWillAppear:(BOOL)animated {
    [self.faceButton setTitle:[self fontName:self.currentFace] forState:UIControlStateNormal];
    self.tableView.alpha = 0.0;
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentFace-1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
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

- (IBAction)didClickFace:(id)sender {
    [UIView animateWithDuration:0.200 animations:^{
        self.tableView.alpha = 1.0;
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellId = @"fontcell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [self fontName:indexPath.row+1];
    return cell;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentFace = indexPath.row+1;
    [self.faceButton setTitle:[self fontName:self.currentFace] forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setInteger:self.currentFace forKey:FONT_FACE_KEY];
    [self.delegate didChangeFont];
    [UIView animateWithDuration:0.200 animations:^{
        self.tableView.alpha = 0.0;
    }];
}

- (NSString*)fontName:(ReaderFont)font {
    if (font == ReaderFontPalatino) return @"Palatino";
    if (font == ReaderFontTimesNewRoman) return @"Times New Roman";
    if (font == ReaderFontHelvetica) return @"Helvetica";
    else return nil;
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
