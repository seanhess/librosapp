//
//  UIViewController+MiniModal.m
//  Libros
//
//  Created by Sean Hess on 2/28/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "UIViewController+MiniModal.h"
#import <objc/runtime.h>

static void *MiniModalKey;

@implementation UIViewController (MiniModal)

- (void)setCurrentMiniModal:(UIViewController*)vc {
    objc_setAssociatedObject(self, &MiniModalKey, vc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewController*)currentMiniModal {
    return objc_getAssociatedObject(self, &MiniModalKey);
}

- (void)clearCurrentMiniModal {
    self.currentMiniModal = nil;
}

- (BOOL)hasCurrentMiniModal {
    return self.currentMiniModal;
}

- (void)presentMiniViewController:(UIViewController *)vc {
    CGRect frame = vc.view.bounds;
    frame.size.width = self.view.frame.size.width;
    frame.origin.x = 0;
    frame.origin.y = self.view.bounds.size.height;
    vc.view.frame = frame;
    [self.view addSubview:vc.view];
    [UIView animateWithDuration:0.200 animations:^{
        CGRect frame = vc.view.frame;
        frame.origin.y -= frame.size.height;
        vc.view.frame = frame;
    }];
    self.currentMiniModal = vc;
}

- (void)dismissMiniViewController {
    UIViewController * vc = self.currentMiniModal;
    [UIView animateWithDuration:0.200 animations:^{
        CGRect frame = vc.view.bounds;
        frame.origin.y = self.view.bounds.size.height;
        vc.view.frame = frame;
    } completion:^(BOOL finished) {
        [vc.view removeFromSuperview];
        [self clearCurrentMiniModal];
    }];
}

@end
