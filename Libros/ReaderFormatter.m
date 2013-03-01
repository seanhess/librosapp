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

-(NSAttributedString*)textForFile:(File*)file withFont:(ReaderFont)font fontSize:(NSInteger)size {
    LBParsedString * parsedString = [[FileService shared] readAsText:file];
    NSAttributedString * chapterText = [self attributedStringForParsed:parsedString withFont:font fontSize:size];
    return chapterText;
}

-(LBParsedString*)parsedStringForMarkup:(NSString*)html {
    NSString * bodyHtml = [self htmlInsideBodyTag:html];
    
    NSMutableString * text = [NSMutableString string];
    LBParsedString * parsedString = [LBParsedString new];
    
    NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:@"(.*?)(<[^>]+>|\\Z)" options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSArray* chunks = [regex matchesInString:bodyHtml options:0 range:NSMakeRange(0, [bodyHtml length])];
    
    LBParsedStringAttribute currentAttribute = LBParsedStringAttributeNone;
    
    for (NSTextCheckingResult* b in chunks) {
        NSArray * parts = [[bodyHtml substringWithRange:b.range] componentsSeparatedByString:@"<"];
        NSString * previousText = parts[0];
        
        [text appendString:previousText];
        
        if (currentAttribute) {
            // if we are IN a bold tag, etc, add that attribute
            [parsedString setAttribute:currentAttribute range:NSMakeRange(text.length - previousText.length, previousText.length)];
        }
        
        // for the NEXT iteration
        if (parts.count > 1) {
            NSString * nextTag = parts[1];
            if ([nextTag hasPrefix:@"b>"]) {
                currentAttribute = LBParsedStringAttributeBold;
            }
            else if ([nextTag hasPrefix:@"i>"]) {
                currentAttribute = LBParsedStringAttributeItalic;
            }
            else {
                currentAttribute = LBParsedStringAttributeNone;
            }
        }
    }
    
    parsedString.text = text;
    
    return parsedString;
}

-(NSString*)boldFontName:(ReaderFont)font {
    if (font == ReaderFontPalatino) return @"Palatino-Bold";
    if (font == ReaderFontTimesNewRoman) return @"TimesNewRomanPSMT-Bold";
    if (font == ReaderFontHelvetica) return @"Helvetica-Bold";
    else return @"Palatino-Bold";
}

-(NSString*)italicFontName:(ReaderFont)font {
    if (font == ReaderFontPalatino) return @"Palatino-Italic";
    if (font == ReaderFontTimesNewRoman) return @"TimesNewRomanPSMT-Italic";
    if (font == ReaderFontHelvetica) return @"Helvetica-Italic";
    else return @"Palatino-Italic";
}

-(NSString*)normalFontName:(ReaderFont)font {
    if (font == ReaderFontPalatino) return @"Palatino-Roman";
    if (font == ReaderFontTimesNewRoman) return @"TimesNewRomanPSMT";
    if (font == ReaderFontHelvetica) return @"Helvetica";
    else return @"Palatino-Roman";
}

// Parses simple, TextEdit-generated
-(NSAttributedString*)attributedStringForParsed:(LBParsedString *)parsed withFont:(ReaderFont)font fontSize:(NSInteger)size {
    
    // TODO: create fonts is slow! Create them on initialization, or lazily
    // make sure you get the font names right or it is REALLY slow
    
    CTFontRef mainFont = CTFontCreateWithName((__bridge CFStringRef)[self normalFontName:font], size, NULL);
    CTFontRef boldFont = CTFontCreateWithName((__bridge CFStringRef)[self boldFontName:font], size, NULL);
    CTFontRef italicFont = CTFontCreateWithName((__bridge CFStringRef)[self italicFontName:font], size, NULL);
    
    CGFloat lineSpacing = 3.0;
    CTTextAlignment alignment = kCTJustifiedTextAlignment;
//    CTTextAlignment alignment = kCTKernAttributeName;
    
    CTParagraphStyleSetting settings[] = {
        {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment},
        {kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &lineSpacing},
    };
    CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, sizeof(settings) / sizeof(settings[0]));
    
    NSMutableAttributedString* text = [[NSMutableAttributedString alloc] initWithString:parsed.text];
    
    
    NSDictionary* mainAttributes = @{
        (NSString*)kCTParagraphStyleAttributeName : (__bridge id)paragraphStyle,
        (NSString*)kCTFontAttributeName: (__bridge id)mainFont
    };
    
    [text addAttributes:mainAttributes range:NSMakeRange(0, text.length)];
    
    [parsed forEachAttribute:^(LBParsedStringAttribute attribute, NSRange range) {
        CTFontRef font;
        if (attribute == LBParsedStringAttributeBold) {
            font = boldFont;
        }
        else if (attribute == LBParsedStringAttributeItalic) {
            font = italicFont;
        }
        else {
            font = mainFont;
        }
        
        NSDictionary* attributes = @{
            (NSString*)kCTFontAttributeName: (__bridge id)font
        };
        
        [text addAttributes:attributes range:range];
    }];
    
    CFRelease(mainFont);
    CFRelease(boldFont);
//    CFRelease(italicFont);
    CFRelease(paragraphStyle);
    
    return text;
}

-(NSString*)htmlInsideBodyTag:(NSString*)html {
    NSArray * chunks = [html componentsSeparatedByString:@"<body>"];
    NSString * bodyChunk = chunks[1];
    return [bodyChunk componentsSeparatedByString:@"</body>"][0];
}

@end
