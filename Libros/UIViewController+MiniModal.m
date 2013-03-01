//
//  UIViewController+MiniModal.m
//  Libros
//
//  Created by Sean Hess on 2/28/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "UIViewController+MiniModal.h"

@implementation UIViewController (MiniModal)

- (void)presentMiniViewController:(UIViewController *)vc animated:(BOOL)flag {
    CGRect frame = vc.view.bounds;
    frame.size.width = self.view.frame.size.width;
    frame.origin.x = 0;
    frame.origin.y = self.view.bounds.size.height;
    vc.view.frame = frame;
    [self.view addSubview:vc.view];
    
    [UIView beginAnimations:@"minimodal" context:nil];
    frame.origin.y -= frame.size.height;
    vc.view.frame = frame;
    [UIView commitAnimations];
}

- (void)dismissMiniViewController:(UIViewController *)vc animated:(BOOL)animated {
    
    [UIView animateWithDuration:0.200 animations:^{
        CGRect frame = vc.view.bounds;
        frame.origin.y = self.view.bounds.size.height;
        vc.view.frame = frame;
    } completion:^(BOOL finished) {
        [vc.view removeFromSuperview];
    }];
    
}

@end
