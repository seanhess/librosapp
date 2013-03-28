//
//  ReaderFontVC2.m
//  Libros
//
//  Created by Sean Hess on 3/27/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "ReaderVolumeVC2.h"
#import <QuartzCore/QuartzCore.h>

#define WIDTH 30
#define HEIGHT 120

@interface ReaderVolumeVC2 ()
@property (nonatomic, strong) UISlider * slider;
@end

@implementation ReaderVolumeVC2

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    self.slider = [UISlider new];
    [self.slider addTarget:self action:@selector(didSlideVolume:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.slider];
    
    self.slider.value = self.value;
    
    // rotating it also flips its coordinate system
    // so x = height, y = width puts it in the upper right corner?
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * 1.5);
    self.slider.layer.anchorPoint = CGPointMake(0, 0);
    CGFloat w = HEIGHT - 8;
    CGFloat h = self.slider.frame.size.height;
    self.slider.frame = CGRectMake(h - self.view.frame.size.width/2 - 4, w + 4, w, h);
    self.slider.transform = trans;
}

- (void)didSlideVolume:(id)slider {
    [self.delegate didSlideVolume:self.slider.value];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
