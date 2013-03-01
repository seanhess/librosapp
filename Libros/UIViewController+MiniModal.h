//
//  UIViewController+MiniModal.h
//  Libros
//
//  Created by Sean Hess on 2/28/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.

#import <UIKit/UIKit.h>

@interface UIViewController (MiniModal)

- (void)presentMiniViewController:(UIViewController *)vc;
- (void)dismissMiniViewController;

- (void)setCurrentMiniModal:(UIViewController*)vc;
- (UIViewController*)currentMiniModal;
- (void)clearCurrentMiniModal;
- (BOOL)hasCurrentMiniModal;

@end
