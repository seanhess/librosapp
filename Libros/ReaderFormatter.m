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
    
    // JUSTIFIED TEXT
    CTTextAlignment alignment = kCTJustifiedTextAlignment;
    CTParagraphStyleSetting settings[] = {
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
    NSDictionary *attrDictionary = @{
    (NSString*)kCTParagraphStyleAttributeName : (__bridge id)paragraphStyle
    };
    
    // FONT
    CTFontRef font = CTFontCreateWithName(CFSTR("Verdana"), 16, NULL);
    
    NSMutableAttributedString* stringCopy = [[NSMutableAttributedString alloc] initWithAttributedString:text];
    [stringCopy addAttributes:attrDictionary range:NSMakeRange(0, [text length])];
    [stringCopy addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)font range:NSMakeRange(0, stringCopy.length)];
    
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
    CTFontRef font = CTFontCreateWithName(CFSTR("Verdana-Bold"), 24, NULL);
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
