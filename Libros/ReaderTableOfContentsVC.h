//
//  ReaderTableOfContentsVC.h
//  Libros
//
//  Created by Sean Hess on 2/15/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReaderTableOfContentsDelegate <NSObject>

-(void)didCloseToc;
-(void)didSelectChapter:(NSInteger)chapter;

@end

@interface ReaderTableOfContentsVC : UIViewController

@property (strong, nonatomic) NSArray * files;
@property (weak, nonatomic) id<ReaderTableOfContentsDelegate>delegate;

@end
