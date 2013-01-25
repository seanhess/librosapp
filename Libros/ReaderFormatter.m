//
//  ReaderFormatter.m
//  Libros
//
//  Created by Sean Hess on 1/25/13.
//  Copyright (c) 2013 Sean Hess. All rights reserved.
//

#import "ReaderFormatter.h"
#import <CoreText/CoreText.h>
#import "FileService.h"

@implementation ReaderFormatter

// READER
// cleans up the text, adds a font and justified alignment, etc
- (NSMutableAttributedString*)formatText:(NSAttributedString *)text {
    CTFontRef font = CTFontCreateWithName(CFSTR("Palatino"), 18, NULL);
    
    CGFloat lineSpacing = 3.0;
    CTTextAlignment alignment = kCTJustifiedTextAlignment;
    
    CTParagraphStyleSetting settings[] = {
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
        {kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &lineSpacing},
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
    
    NSDictionary *attrDictionary = @{
        (NSString*)kCTParagraphStyleAttributeName : (__bridge id)paragraphStyle,
        (NSString*)kCTFontAttributeName : (__bridge id)font
    };
    
    NSMutableAttributedString* stringCopy = [[NSMutableAttributedString alloc] initWithAttributedString:text];
    [stringCopy addAttributes:attrDictionary range:NSMakeRange(0, [text length])];
    
    return stringCopy;
}

-(NSAttributedString*)textForChapter:(NSInteger)chapter {
    NSString * bookPlainString = [[FileService shared] readAsText:self.files[chapter]];
    NSMutableAttributedString * chapterText = [self formatText:[[NSAttributedString alloc] initWithString:bookPlainString]];
    [chapterText insertAttributedString:[self chapterHeading:chapter] atIndex:0];
    return chapterText;
}

-(NSAttributedString*)chapterHeading:(NSInteger)chapter {
    File* file = self.files[chapter];
    CTFontRef font = CTFontCreateWithName(CFSTR("Palatino-Bold"), 24, NULL);
    NSString * headerWithNewline = [NSString stringWithFormat:@"%@\n\n", file.name];
    
    
    // Alignment
    CTTextAlignment alignment = kCTCenterTextAlignment;
    CTParagraphStyleSetting settings[] = {
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
    
    NSMutableAttributedString * heading = [[NSMutableAttributedString alloc] initWithString:headerWithNewline];
    NSRange fullRange = NSMakeRange(0, heading.length);
    [heading addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)font range:fullRange];
    [heading addAttribute:(NSString*)kCTParagraphStyleAttributeName value:(__bridge id)paragraphStyle range:fullRange];
    return heading;
}

@end
