//
//  FTTimeFrequencySlider.m
//  FitHeart
//
//  Created by Bitgears on 02/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "FTFrequencySlider.h"
#import <CoreText/CoreText.h>

static int MAX_WIDTH = 56;
static int OFFSET_3_POS[] = {23, 94, 170};
static int OFFSET_4_POS[] = {21, 86, 150, 216};
static int OFFSET_5_POS[] = {23, 72, 120, 169, 219};
static int OFFSET_6_POS[] = {23, 72, 120, 169, 219, 267};
static float OFFSET_Y = 10;

@interface FTFrequencySlider() {
    UIImage *background;
    float bkgX;
    float bkgY;
    float handleX;
    float handleY;
    NSArray *positions;
    NSInteger total_positions;
}

@end

@implementation FTFrequencySlider

@synthesize position;
@synthesize handleColor;
@synthesize handleSize;
@synthesize handleInternalColor;
@synthesize handleInternalSize;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame withPositions:(NSArray*)pos
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        position = 0;
        positions = pos;
        total_positions = [positions count];
        
        background = [UIImage imageNamed:[NSString stringWithFormat:@"frequency_slider_%li", (long)total_positions]  ];
        
        bkgX = (frame.size.width - background.size.width) / 2;
        bkgY = OFFSET_Y;
        
        self.accessibilityTraits = UIAccessibilityTraitAdjustable;
        [self setIsAccessibilityElement:YES];
        self.userInteractionEnabled = YES;
        [self setAccessibilityLabel:@"reminder frequency"];
        //[self setAccessibilityHint:@"Tap to select reminder frequency"];

        
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();


    CGPoint imagePoint = CGPointMake(bkgX, bkgY);
    [background drawAtPoint:imagePoint];
    
    [self drawTextInfo:ctx];
    [self drawTheHandle:ctx];
    
}

-(CGPoint)handlePosition:(int)pos {
    CGPoint handleCenter;
    float  y = bkgY + (background.size.height / 2);
    switch (total_positions) {
        case 3: handleCenter = CGPointMake(bkgX+OFFSET_3_POS[pos],y); break;
        case 4: handleCenter = CGPointMake(bkgX+OFFSET_4_POS[pos],y); break;
        case 5: handleCenter = CGPointMake(bkgX+OFFSET_5_POS[pos],y); break;
        case 6: handleCenter = CGPointMake(bkgX+OFFSET_6_POS[pos],y); break;
    }
    
    return handleCenter;
}


/** Draw a white knob over the circle **/
-(void) drawTheHandle:(CGContextRef)ctx{
    
    CGContextSaveGState(ctx);

    CGPoint handleCenter =  [self handlePosition:position];
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 4, [UIColor blackColor].CGColor);
    [handleColor set];
    float offset = (handleSize / 2);
    CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x-offset, handleCenter.y-offset, handleSize, handleSize));
    CGContextRestoreGState(ctx);
    
    CGContextSaveGState(ctx);
    //CGContextSetShadowWithColor(ctx, CGSizeMake(2, 2), 3, [UIColor whiteColor].CGColor);
    [handleInternalColor set];
    float diff = ((handleSize - handleInternalSize)/2) - offset;
    CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x+diff, handleCenter.y+diff, handleInternalSize, handleInternalSize));
    
    CGContextRestoreGState(ctx);
}

-(void) drawTextInfo:(CGContextRef)ctx {
    CGContextSaveGState(ctx);
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    for (int i=0; i<[positions count]; i++) {
        CGColorRef color = [UIColor lightGrayColor].CGColor;
        if (i==position)
            color = handleColor.CGColor;

        
        CTFontRef font = CTFontCreateWithName((CFStringRef)@"SourceSansPro-Semibold", 12.0f, nil);
        NSString *value = [positions objectAtIndex:i];
        CGPoint center =  [self handlePosition:i];
        
        // Paragraph
        CTTextAlignment alignment = kCTCenterTextAlignment;
        CTParagraphStyleSetting _settings[] = {    {kCTParagraphStyleSpecifierAlignment, sizeof(alignment), &alignment} };
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(_settings, sizeof(_settings) / sizeof(_settings[0]));
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:value];
        
        CFAttributedStringSetAttribute((__bridge CFMutableAttributedStringRef) attrString, CFRangeMake(0, attrString.length), kCTFontAttributeName, font);
        CFAttributedStringSetAttribute((__bridge CFMutableAttributedStringRef) attrString, CFRangeMake(0, attrString.length), kCTForegroundColorAttributeName, color);
        CFAttributedStringSetAttribute((__bridge CFMutableAttributedStringRef) attrString, CFRangeMake(0, attrString.length), kCTForegroundColorAttributeName, color);
        CFAttributedStringSetAttribute((__bridge CFMutableAttributedStringRef) attrString, CFRangeMake(0, attrString.length),  kCTParagraphStyleAttributeName, paragraphStyle);
        
        
        float offset_y = self.frame.size.height - background.size.height - center.y;
        
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrString);
        
        CGSize textSize = [self sizeOfAttrString:framesetter];
        CGRect textRect = CGRectMake(center.x - (MAX_WIDTH/2), offset_y, MAX_WIDTH, textSize.height);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, textRect );
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attrString length]), path, NULL);
        CFRange frameRange = CTFrameGetVisibleStringRange(frame); //5
        float row = ceilf( (float)attrString.length / (float)frameRange.length);
        if (row>1) {
            CGRect textRect = CGRectMake(center.x - (MAX_WIDTH/2), offset_y-textSize.height, MAX_WIDTH, textSize.height*(row-1));
            CGPathAddRect(path, NULL, textRect );
            frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attrString length]), path, NULL);

        }
        
        CTFrameDraw(frame, ctx);

        CFRelease(framesetter);
        CFRelease(frame);
        CFRelease(path);

        
    }
 
    CGContextRestoreGState(ctx);

}

/** Tracking is started **/
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    
    //Get touch location
    CGPoint lastPoint = [touch locationInView:self];
    //Use the location to design the Handle
    [self movehandle:lastPoint];
    
    //We need to track continuously
    return YES;
}

/** Track continuos touch event (like drag) **/
-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    
    //Get touch location
    CGPoint lastPoint = [touch locationInView:self];
    
    //Use the location to design the Handle
    NSLog(@"%f %f", lastPoint.x, lastPoint.y);
    [self movehandle:lastPoint];
    
    //Control value has changed, let's notify that
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    return YES;
}

/** Move the Handle **/
-(void)movehandle:(CGPoint)lastPoint{
    
    if (UIAccessibilityIsVoiceOverRunning()) {
        /*
        position++;
        if (position>=total_positions) position = 0;
        [self.delegate frequencyChanged:position];
        NSString* selfreq = (NSString*)[positions objectAtIndex:position];
        [self setAccessibilityValue:[NSString stringWithFormat:@"selected frequency is %@",selfreq]  ];
        //Redraw
        [self setNeedsDisplay];
        */
        //UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, captionText);
    }
    else {
        float handleHalfSize = handleSize / 2;
        for (int i=0; i<total_positions; i++) {
            CGPoint handleCenter =  [self handlePosition:i];
            if ( (lastPoint.x > (handleCenter.x-handleHalfSize)) && (lastPoint.x < (handleCenter.x+handleHalfSize)) ) {
                position = i;
                [self.delegate frequencyChanged:position];
                //Redraw
                [self setNeedsDisplay];
            }
        }
    }

    

    
}

/** Track is finished **/
-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    
}

- (CGSize) sizeOfAttrString:(CTFramesetterRef)framesetter
{
    return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(0, CGFLOAT_MAX), NULL);
}

-(void)updatePosition:(int)newpos {
    position = newpos;
    [self.delegate frequencyChanged:position];

    [self setAccessibilityValue:[NSString stringWithFormat:@"selected frequency %@" , [positions objectAtIndex:position]]];
    [self setNeedsDisplay];
}

-(void)accessibilityIncrement {
    position++;
    if (position>=[positions count])
        position = 0;
        
    [self updatePosition:position];
    
}
-(void)accessibilityDecrement {
    position--;
    if (position<0)
        position = [positions count]-1;
    
    [self updatePosition:position];
}




@end
