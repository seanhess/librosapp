//
//  StoreBookResultsFilterView.m
//  Libros
//
//  Created by Sean Hess on 2/7/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "StoreBookResultsFilterView.h"
#import "Appearance.h"

#define HORIZONTAL_PADDING 8
#define VERTICAL_PADDING 8
#define HEIGHT 40

@interface StoreBookResultsFilterView ()
@property (strong, nonatomic) UISegmentedControl *segments;
@end

@implementation StoreBookResultsFilterView

+ (StoreBookResultsFilterView*)filterView {
    return [StoreBookResultsFilterView new];
}

- (id)init {
    self = [super init];
    if (self) {
        NSArray * items = @[@"Todos", @"Texto", @"Audio"];
        self.frame = CGRectMake(0, 0, 100, HEIGHT); // just gives it an initial height
        self.segments = [[UISegmentedControl alloc] initWithItems:items];
        self.segments.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.segments.frame = CGRectMake(HORIZONTAL_PADDING, 12, self.frame.size.width-2*HORIZONTAL_PADDING, self.frame.size.height - 2*VERTICAL_PADDING);
        self.segments.segmentedControlStyle = UISegmentedControlStyleBar;
        self.segments.tintColor = Appearance.boringGrayColor;
        [self addSubview:self.segments];
        
        [self.segments addTarget:self action:@selector(selectItem:) forControlEvents:UIControlEventValueChanged];
        self.segments.selectedSegmentIndex = 0;
    }
    return self;
}

- (void)selectItem:(id)sender {
    [self renderSelectedSegment];
    [self.delegate didSelectFilter:self.segments.selectedSegmentIndex];
}

- (void)renderSelectedSegment {
    for (UIButton * segment in self.segments.subviews) {
        if (segment.selected)
            [segment setTintColor:Appearance.highlightBlue];
        else
            [segment setTintColor:Appearance.boringGrayColor];
    }
}

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
