//
//  StoreBookResultsFilterView.m
//  Libros
//
//  Created by Sean Hess on 2/7/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "StoreBookResultsFilterView.h"

@interface StoreBookResultsFilterView ()
@property (weak, nonatomic) IBOutlet ColoredButton *button;
@end

@implementation StoreBookResultsFilterView


// creates one for you from the nib and initializes it correctly
+ (StoreBookResultsFilterView*)filterView {
    StoreBookResultsFilterView * view = [[[NSBundle mainBundle] loadNibNamed:@"StoreBookResultsFilterView" owner:self options:nil] objectAtIndex:0];
    return view;
}

// meant to be created by loading via nib
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib {
    self.button.style = ColoredButtonStyleBlack;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)didTapButton:(id)sender {
    [self.delegate didTapFilterButton];
}

-(void)setButtonTitle:(NSString *)title {
    [self.button setTitle:title forState:UIControlStateNormal];
}

@end
