//
//  UIViewController+MiniModal.h
//  Libros
//
//  Created by Sean Hess on 2/28/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.

#import <UIKit/UIKit.h>

@interface UIViewController (MiniModal)

- (void)presentMiniViewController:(UIViewController *)vc animated:(BOOL)animated;
- (void)dismissMiniViewController:(UIViewController *)vc animated:(BOOL)animated;

@end
