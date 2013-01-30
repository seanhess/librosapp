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

-(NSAttributedString*)textForChapter:(NSInteger)chapter {
    NSString * bookPlainString = [[FileService shared] readAsText:self.files[chapter]];
    NSAttributedString * chapterText = [self textForMarkup:bookPlainString];
    return chapterText;
}

// Parses simple, TextEdit-generated 
-(NSAttributedString*)textForMarkup:(NSString *)html {
    NSString * bodyHtml = [self htmlInsideBodyTag:html];
    
    // FONTS and FORMATTING
    CTFontRef mainFont = CTFontCreateWithName(CFSTR("Palatino"), 18, NULL);
    CTFontRef boldFont = CTFontCreateWithName(CFSTR("Palatino-bold"), 18, NULL);
    CTFontRef italicFont = CTFontCreateWithName(CFSTR("Palatino-italic"), 18, NULL);
    CTFontRef currentFont = mainFont;
    
    CGFloat lineSpacing = 3.0;
    CTTextAlignment alignment = kCTJustifiedTextAlignment;
    
    CTParagraphStyleSetting settings[] = {
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
        {kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &lineSpacing},
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
    
    NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:@""];
    NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:@"(.*?)(<[^>]+>|\\Z)" options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSArray* chunks = [regex matchesInString:bodyHtml options:0 range:NSMakeRange(0, [bodyHtml length])];
    
    for (NSTextCheckingResult* b in chunks) {
        NSArray * parts = [[bodyHtml substringWithRange:b.range] componentsSeparatedByString:@"<"];
        NSString * previousText = parts[0];
        
        NSDictionary* attributes = @{
            (NSString*)kCTParagraphStyleAttributeName : (__bridge id)paragraphStyle,
            (NSString*)kCTFontAttributeName: (__bridge id)currentFont
        };
        
        NSAttributedString * run = [[NSAttributedString alloc] initWithString:previousText attributes:attributes];
        [text appendAttributedString:run];
        
        if (parts.count > 1) {
            NSString * nextTag = parts[1];
            if ([nextTag hasPrefix:@"b"]) {
                currentFont = boldFont;
            }
            else if ([nextTag hasPrefix:@"i"]) {
                currentFont = italicFont;
            }
            else {
                currentFont = mainFont;
            }
        }
    }
    
    CFRelease(mainFont);
    CFRelease(boldFont);
    CFRelease(italicFont);
    CFRelease(paragraphStyle);
    
    return text;
}

-(NSString*)htmlInsideBodyTag:(NSString*)html {
    NSArray * chunks = [html componentsSeparatedByString:@"<body>"];
    NSString * bodyChunk = chunks[1];
    return [bodyChunk componentsSeparatedByString:@"</body>"][0];
}

@end
