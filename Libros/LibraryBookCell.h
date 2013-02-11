//
//  LibraryBookCell.h
//  Libros
//
//  Created by Sean Hess on 2/11/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@protocol LibraryBookCellDelegate <NSObject>

-(void)didTapAudio:(Book*)book;
-(void)didTapText:(Book*)book;

@end

@interface LibraryBookCell : UITableViewCell

@property (nonatomic, strong) Book * book;
@property (nonatomic, weak) id<LibraryBookCellDelegate>delegate;

@end
