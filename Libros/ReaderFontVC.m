//
//  ReaderFontVC.m
//  Libros
//
//  Created by Sean Hess on 2/28/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "ReaderFontVC.h"
#import "ReaderFormatter.h"

#define MIN_SIZE 10
#define DEF_SIZE 18
#define MAX_SIZE 32

#define FONT_SIZE_KEY @"fontSize"
#define FONT_FACE_KEY @"fontFace"

@interface ReaderFontVC () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) ReaderFormatter *formatter;
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
        
        self.formatter = [ReaderFormatter new];
    }
    return self;
}

// does NOT get called if you just create it
- (void)viewDidLoad
{
    self.contentSizeForViewInPopover = self.view.frame.size;
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[self rowForFont:self.currentFace] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * cellId = @"fontcell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    ReaderFont font = [self fontForRow:indexPath.row];
    cell.textLabel.text = [self.formatter humanFontName:font];
    cell.textLabel.font = [UIFont fontWithName:[self.formatter normalFontName:font] size:14];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

-(ReaderFont)fontForRow:(NSInteger)row {
    return row+1;
}

-(NSInteger)rowForFont:(ReaderFont)font {
    return font-1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentFace = [self fontForRow:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setInteger:self.currentFace forKey:FONT_FACE_KEY];
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
