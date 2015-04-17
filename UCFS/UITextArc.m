//
//  UITextArc.m
//  FitHeart
//
//  Created by Bitgears on 21/11/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "UITextArc.h"
#import <CoreText/CoreText.h>


@interface UITextArc() {
    CTFontRef ctfont;
}

@end

@implementation UITextArc

@synthesize text;
@synthesize angle;
@synthesize radius;
@synthesize color;
@synthesize textAlignment;
@synthesize textOrientation;


-(id)initWithFrame:(CGRect)frame withFontName:(NSString*)fontName withFontSize:(float)fontSize {
    
    self = [super initWithFrame:frame];
    
    if(self){
        self.opaque = NO;
        text = @"";
        radius = 10;
        angle = 0;
        textAlignment = TEXTARC_ALIGN_LEFT;
        color = [UIColor whiteColor];
        textOrientation = TEXTARC_ORIEN_EXTERNAL;
        
        //font
        ctfont = CTFontCreateWithName((CFStringRef)fontName, fontSize, nil);

    }
    
    return self;
}



-(void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, self.bounds.size.width/2, self.bounds.size.height/2);
    CGContextScaleCTM(context, 1.0, -1.0);
    //CGContextRotateCTM(context, 0.2);
    

    //[self drawPinAtContext:context];
    
    [self drawStringAtContext:context];
    

}


- (void) drawPinAtContext:(CGContextRef)context
{
    for (int index = 0; index < 36; index++)  {
        float angle_p = ((index*10) *  M_PI) / 180;
        float x = radius * cos(angle_p);
        float y = radius * sin(angle_p);
        float color_scale = (index*7) / 255.0;
        UIColor *color_p = [UIColor colorWithRed:color_scale green:color_scale blue:color_scale alpha:1.0 ];
        
        CGContextSaveGState(context);
        [color_p set];

        CGContextFillEllipseInRect(context, CGRectMake(x-8, y-8, 16, 16));
        
        CGContextRestoreGState(context);
    }
    
}


- (void) drawStringAtContext:(CGContextRef)context
{

    
    //attributed string for text
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    CFAttributedStringSetAttribute((__bridge CFMutableAttributedStringRef) attrString, CFRangeMake(0, attrString.length), kCTFontAttributeName, ctfont);
    CFAttributedStringSetAttribute((__bridge CFMutableAttributedStringRef) attrString, CFRangeMake(0, attrString.length), kCTForegroundColorAttributeName, color.CGColor);
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString); //3
    
    //lunghezza testo
    CGSize textSize = [self sizeOfAttrString:framesetter];
    
    //angolo occupato dal testo in proporzione rispetto alla circonferenza
    float textAngle = textSize.width / radius;
    
    //centro
    float drawingAngle = angle;
    if (textOrientation==TEXTARC_ORIEN_EXTERNAL) {
        if (textAlignment==TEXTARC_ALIGN_CENTER)
            drawingAngle += textAngle / 2;
        else
            if (textAlignment==TEXTARC_ALIGN_RIGHT)
                drawingAngle += textAngle;
    }
    else {
        if (textAlignment==TEXTARC_ALIGN_CENTER)
            drawingAngle -= textAngle / 2;
        else
            if (textAlignment==TEXTARC_ALIGN_RIGHT)
                drawingAngle -= textAngle;
    }

    

    for (int index = 0; index < [text length]; index++)  {
        NSRange range = {index, 1};
        NSString* letter = [text substringWithRange:range];

        float x = radius * cos(drawingAngle);
        float y = radius * sin(drawingAngle);
        
        CGContextSaveGState(context);
        [color set];
        
        //attributed string for letter
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:letter];
        CFAttributedStringSetAttribute((__bridge CFMutableAttributedStringRef) attrString, CFRangeMake(0, attrString.length), kCTFontAttributeName, ctfont);
        CFAttributedStringSetAttribute((__bridge CFMutableAttributedStringRef) attrString, CFRangeMake(0, attrString.length), kCTForegroundColorAttributeName, color.CGColor);
        
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString); //3
        CGSize charSize = [self sizeOfAttrString:framesetter];
        
        //centra
        CGRect letterRect = CGRectMake(0, 0, charSize.width, charSize.height);
        CGMutablePathRef path = CGPathCreateMutable(); //1
        CGPathAddRect(path, NULL, letterRect );
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attrString length]), path, NULL);

        CGContextTranslateCTM(context, x, y);
        //ruota rispetto all'origine
        float letterAngle = (charSize.width / radius);
        
        if (textOrientation==TEXTARC_ORIEN_EXTERNAL)
            CGContextRotateCTM(context, (drawingAngle-letterAngle)-(M_PI/2));
        else
            CGContextRotateCTM(context, (drawingAngle+letterAngle)+(M_PI/2));
        
        CTFrameDraw(frame, context); //4

        CGContextRestoreGState(context);
        
        if (textOrientation==TEXTARC_ORIEN_EXTERNAL)
            drawingAngle -= letterAngle;
        else
            drawingAngle += letterAngle;
        
        CGPathRelease(path);
        CFRelease(frame);
        CFRelease(framesetter);
        
    }
    
    
    CFRelease(framesetter);

    
}

- (CGSize) sizeOfAttrString:(CTFramesetterRef)framesetter
{
    return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(0, CGFLOAT_MAX), NULL);
}

- (CGSize) sizeOfString:(NSString*)string withFont:(UIFont *)fontToUse
{
    if ([self respondsToSelector:@selector(sizeWithAttributes:)])
    {
        NSDictionary* attribs = @{NSFontAttributeName:fontToUse};
        return ([string sizeWithAttributes:attribs]);
    }
    return ([string sizeWithFont:fontToUse]);
}

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];

    return NO;
}

-(void)dealloc {
    text = nil;
    color = nil;
    CFRelease(ctfont);
}



@end
