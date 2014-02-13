//
//  StoreBookResultsFilterView.m
//  Libros
//
//  Created by Sean Hess on 2/7/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "StoreBookResultsFilterView.h"
#import "Appearance.h"

@interface StoreBookResultsFilterView ()
@property (strong, nonatomic) UISegmentedControl *segments;
@property (strong, nonatomic) UIImageView * backgroundView;
@end

@implementation StoreBookResultsFilterView

+ (StoreBookResultsFilterView*)filterView {
    return [StoreBookResultsFilterView new];
}

- (id)init {
    self = [super init];
    if (self) {
        
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar-secondary-bg.png"]];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.backgroundView];
        
        NSArray * items = @[NSLocalizedString(@"Filter All", nil), NSLocalizedString(@"Filter Text",nil), NSLocalizedString(@"Filter Audio",nil)];
        self.frame = CGRectMake(0, 0, 100, 36); // it ignores the width
        self.segments = [[UISegmentedControl alloc] initWithItems:items];
        self.segments.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.segments.frame = CGRectMake(4, 4, self.frame.size.width-2*4, 26);
        self.segments.segmentedControlStyle = UISegmentedControlStyleBar;
//        self.segments.tintColor = Appearance.darkControlGrayColor;
        [self addSubview:self.segments];
        
        [self.segments addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventValueChanged];
        self.segments.selectedSegmentIndex = 0;
    }
    return self;
}

- (void)selectItem:(id)sender {
//    [self renderSelectedSegment];
    [self.delegate didSelectFilter:self.segments.selectedSegmentIndex];
}

//- (void)renderSelectedSegment {
//    for (UIButton * segment in self.segments.subviews) {
//        if (segment.selected)
//            [segment setTintColor:Appearance.adjustedHighlightBlueForShadows];
//        else
//            [segment setTintColor:Appearance.darkControlGrayColor];
//    }
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

//- (IBAction)didTapButton:(id)sender {
//    [self.delegate didTapFilterButton];
//}
//
//-(void)setButtonTitle:(NSString *)title {
//    [self.button setTitle:title forState:UIControlStateNormal];
//}

@end
