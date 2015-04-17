//
//  FTCircularEntriesGraph.m
//  FitHeart
//
//  Created by Bitgears on 26/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FTCircularEntriesGraph.h"
#import <CoreText/CoreText.h>


/** Helper Functions **/
#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )



@interface FTCircularEntriesGraph() {
    CGPoint centerPoint;
    CGPoint progressPoint;
    CGPoint unitPoint;
    float radius;
    int angle;
    NSString* centerText;
    CTFontRef bigFont;
    CTFontRef normalFont;
    CTFontRef mediumFont;
    CTFontRef smallFont;
    
    float currentProgress;
    float currentValue;
    float currentValue2;
    NSString* currentUnit;
    NSString* currentProgressStr;
}

@end


@implementation FTCircularEntriesGraph

@synthesize wheelBackgroundColor;
@synthesize wheelBackgroundSize;
@synthesize wheelForegroundColor;
@synthesize wheelRadius;

-(void) initWithRadius:(float)wheelradius withSize:(float)size {
    angle = 0;
    currentProgress =0;
    currentValue = 0;
    currentValue2 = 0;
    currentUnit = @"";
    currentProgressStr = @"0";
    wheelRadius = wheelradius;
    wheelBackgroundSize = size;
    radius = wheelRadius-(wheelBackgroundSize/2);
    bigFont = CTFontCreateWithName((CFStringRef)@"SourceSansPro-Bold", 52.0f, nil);
    normalFont = CTFontCreateWithName((CFStringRef)@"SourceSansPro-Bold", 40.0f, nil);
    mediumFont = CTFontCreateWithName((CFStringRef)@"SourceSansPro-Bold", 30.0f, nil);
    smallFont = CTFontCreateWithName((CFStringRef)@"SourceSansPro-Regular", 15.0f, nil);

}

-(id)initWithFrame:(CGRect)frame withRadius:(float)wheelradius withSize:(float)size {
    
    self = [super initWithFrame:frame];
    if(self){
        self.opaque = NO;
        //Get the center
        centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        progressPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 +5 );
        unitPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 30);
        [self initWithRadius:wheelradius withSize:size];

    }
    
    return self;
}


-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    
    
    /** Draw the Background **/
    
    //circle background
    CGContextSaveGState(ctx);
    [[UIColor whiteColor] set];
    CGContextFillEllipseInRect(ctx, CGRectMake(centerPoint.x-wheelRadius, centerPoint.y-wheelRadius, wheelRadius*2, wheelRadius*2));
    CGContextRestoreGState(ctx);
    
    //background wheel
    CGContextAddArc(ctx, centerPoint.x, centerPoint.y, radius, 0, 2*M_PI, 0);
    CGContextSetStrokeColorWithColor(ctx, wheelBackgroundColor.CGColor );
    //Define line width and cap
    CGContextSetLineWidth(ctx, wheelBackgroundSize);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //background wheel
    CGContextAddArc(ctx, centerPoint.x, centerPoint.y, radius, ToRad(-90), ToRad(angle-90), 0);
    CGContextSetStrokeColorWithColor(ctx, wheelForegroundColor.CGColor );
    //Define line width and cap
    CGContextSetLineWidth(ctx, wheelBackgroundSize);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    if ([currentProgressStr length]==4)
        [self drawText:ctx withValue:currentProgressStr withColor:wheelForegroundColor withFont:normalFont at:progressPoint];
    else
        if ([currentProgressStr length]>4)
            [self drawText:ctx withValue:currentProgressStr withColor:wheelForegroundColor withFont:mediumFont at:progressPoint];
        else
            [self drawText:ctx withValue:currentProgressStr withColor:wheelForegroundColor withFont:bigFont at:progressPoint];
    
    [self drawText:ctx withValue:currentUnit withColor:[UIColor blackColor] withFont:smallFont at:unitPoint];
    
}


-(void)drawText:(CGContextRef)ctx withValue:(NSString*)text withColor:(UIColor*)color withFont:(CTFontRef)font at:(CGPoint)center {
    
    if (text!=nil) {
        CGContextSaveGState(ctx);
        
        CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
        CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
        CGContextScaleCTM(ctx, 1.0, -1.0);
        
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
        CFAttributedStringSetAttribute((__bridge CFMutableAttributedStringRef) attrString, CFRangeMake(0, attrString.length), kCTFontAttributeName, font);
        CFAttributedStringSetAttribute((__bridge CFMutableAttributedStringRef) attrString, CFRangeMake(0, attrString.length), kCTForegroundColorAttributeName, color.CGColor);
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
        CGSize textSize = [self sizeOfAttrString:framesetter];
        CGRect textRect = CGRectMake(center.x - (textSize.width/2), center.y - (textSize.height/2) , textSize.width, textSize.height);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, textRect );
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attrString length]), path, NULL);
        
        CTFrameDraw(frame, ctx);
        
        CGPathRelease(path);
        CFRelease(frame);
        CFRelease(framesetter);
        
        CGContextRestoreGState(ctx);
    }
    
}

- (CGSize) sizeOfAttrString:(CTFramesetterRef)framesetter
{
    return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(0, CGFLOAT_MAX), NULL);
}


- (void)resetWithProgress:(float)progress withValue:(float)value withUnit:(NSString*)unit {
    currentProgress = progress;
    currentValue = value;
    currentUnit = unit;
    currentProgressStr = [NSString stringWithFormat:@"%i", (int)(trunc(currentProgress))];
    if (currentValue>0)
        angle = 360 * (currentProgress / currentValue);
    if (angle>360) {
        angle = 360;
    }
}

- (void)resetWithProgress:(float)progress withValue:(float)value withValue2:(float)value2 withUnit:(NSString*)unit {
    currentProgress = progress;
    currentValue = value;
    currentValue2 = value2;
    currentUnit = unit;
    currentProgressStr = [NSString stringWithFormat:@"%i/%i", (int)(trunc(currentProgress)), (int)trunc(value2) ];
    if (currentValue>0)
        angle = 360 * (currentProgress / currentValue);
    if (angle>360) {
        angle = 360;
    }
}

-(void)dealloc {
    CFRelease(bigFont);
    CFRelease(normalFont);
    CFRelease(mediumFont);
    CFRelease(smallFont);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
