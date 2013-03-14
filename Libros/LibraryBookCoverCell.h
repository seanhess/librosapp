//
//  LibraryBookCoverCell.h
//  Libros
//
//  Created by Sean Hess on 2/22/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

#define COVER_IMAGE_WIDTH 89
#define COVER_IMAGE_HEIGHT 135


@interface LibraryBookCoverCell : UICollectionViewCell
@property (nonatomic, strong) Book * book;

-(UIImage*)cachedImage;
-(CGRect)cachedImageFrame;

@end
