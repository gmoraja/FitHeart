//
//  TBCircularSlider.m
//  TB_CircularSlider
//
//  Created by Yari Dareglia on 1/12/13.
//  Copyright (c) 2013 Yari Dareglia. All rights reserved.
//

#import "TBCircularSlider.h"
#import <CoreText/CoreText.h>


/** Helper Functions **/
#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )

/** Parameters **/
#define TB_SAFEAREA_PADDING 60


#pragma mark - Private -


@interface TBCircularSlider(){


    CGPoint centerPoint;
    UIImage *guideImage;
    CGPoint guideImagePoint;
    float radius;
    BOOL isSliding;
    UIColor *shadowColor;


    int angle;
    int lastAngle;
    BOOL halfCompleted;
    CGPoint handleCenter;
    BOOL isHandleTouched;
    int wheelLoop;
    
    NSString* centerText;
    
    CTFontRef font;
    CTFontRef smallFont;
}

@end


#pragma mark - Implementation -

@implementation TBCircularSlider

@synthesize wheelBackgroundColor;
@synthesize wheelBackgroundSize;
@synthesize guideBackgroundColor;
@synthesize guideForegroundColor;
@synthesize handleColor;
@synthesize handleSize;
@synthesize guideSize;
@synthesize handleInternalColor;
@synthesize handleInternalSize;
@synthesize startValue;
@synthesize endValue;
@synthesize defaultValue;
@synthesize stepValue;
@synthesize wheelRadius;
@synthesize increment;

-(void) initWithRadius:(float)wheelradius withSize:(float)size {
    increment = 0;
    isSliding = false;
    isHandleTouched = FALSE;
    wheelLoop = 0;
    lastAngle = 90;
    halfCompleted = FALSE;
    angle = 90;
    wheelRadius = wheelradius;
    wheelBackgroundSize = size;
    radius = wheelRadius-(wheelBackgroundSize/2);
    shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    font = CTFontCreateWithName((CFStringRef)@"SourceSansPro-Regular", 22.0f, nil);
    smallFont = CTFontCreateWithName((CFStringRef)@"SourceSansPro-Regular", 16.0f, nil);
    
}

- (void)initGuideImageWithFrame:(CGRect)frame {
    
    guideImage = [UIImage imageNamed:@"circular_slider_guide.png"];
    float bkgX = (frame.size.width - guideImage.size.width) / 2;
    float bkgY = (frame.size.height - guideImage.size.height) / 2;
    guideImagePoint = CGPointMake(bkgX, bkgY);
}


-(id)initWithFrame:(CGRect)frame withRadius:(float)wheelradius withSize:(float)size {
    
    self = [super initWithFrame:frame];
    if(self){
        self.opaque = NO;
        //Get the center
        centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [self initWithRadius:wheelradius withSize:size];
        [self initGuideImageWithFrame:frame];
    }
    
    return self;
}


-(BOOL)isPoint:(CGPoint)touchPoint inHandle:(CGPoint)handlePoint withSize:(float)size {
    return (
                ( touchPoint.x>=handlePoint.x && touchPoint.x<=(handlePoint.x+size) ) &&
                ( touchPoint.y>=handlePoint.y && touchPoint.y<=(handlePoint.y+size) )
            );
}


#pragma mark - UIControl Override -

/** Tracking is started **/
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    
    isHandleTouched = FALSE;
    
    //Get touch location
    CGPoint touchPoint = [touch locationInView:self];
    //check
    if ( [self isPoint:touchPoint inHandle:handleCenter withSize:handleSize] ) {
        isHandleTouched = TRUE;
        return YES;
    }
    
    return NO;
}



/** Track continuos touch event (like drag) **/
-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];

        //Get touch location
        CGPoint lastPoint = [touch locationInView:self];
        if (isHandleTouched)
            [self movehandle:lastPoint];
        /*
        int newAngle = [self angleAtPoint:lastPoint];
        
        if (isHandleTouched) {
                angle = newAngle;
                handleCenter =  [self pointFromAngle:angle size:handleSize];
        }
        */
        //Control value has changed, let's notify that
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        isSliding = YES;

    [self setNeedsDisplay];
    
    return YES;
}

/** Track is finished **/
-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];

    isSliding = NO;
    
}


#pragma mark - Drawing Functions - 

//Use the draw rect to draw the Background, the Circle and the Handle 
-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    
    
/** Draw the Background **/
    
    //circle background
    CGContextSaveGState(ctx);
    [[UIColor whiteColor] set];
    CGContextFillEllipseInRect(ctx, CGRectMake(centerPoint.x-wheelRadius, centerPoint.y-wheelRadius, wheelRadius*2, wheelRadius*2));
    CGContextRestoreGState(ctx);
    
    //Create the path
    CGContextAddArc(ctx, centerPoint.x, centerPoint.y, radius, 0, 2*M_PI, 0);
    CGContextSetStrokeColorWithColor(ctx, wheelBackgroundColor.CGColor );
    //Define line width and cap
    CGContextSetLineWidth(ctx, wheelBackgroundSize);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    CGContextDrawPath(ctx, kCGPathStroke);
    
    //Create the path
    CGContextAddArc(ctx, centerPoint.x, centerPoint.y, radius, 0, 2*M_PI, 0);
    
    //Set the stroke color to black
    [guideForegroundColor setStroke];
    //Define line width and cap
    CGContextSetLineWidth(ctx, guideSize);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    //draw it!
    CGContextDrawPath(ctx, kCGPathStroke);
    
    [self drawText:ctx withValue:centerText withColor:[UIColor blackColor] at:centerPoint];
    
    [self drawTheHandle:ctx atPoint:handleCenter withColor:handleColor withIntColor:handleInternalColor];

}

/** Draw a white knob over the circle **/
-(void) drawTheHandle:(CGContextRef)ctx atPoint:(CGPoint)center withColor:(UIColor*)color withIntColor:(UIColor*)intColor {
 
    CGContextSaveGState(ctx);
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 4, shadowColor.CGColor);
    [color set];
    CGContextFillEllipseInRect(ctx, CGRectMake(center.x, center.y, handleSize, handleSize));
    CGContextRestoreGState(ctx);

    float offset = (handleSize - handleInternalSize) / 2;
    CGPoint handleInternalCenter = CGPointMake(center.x+offset, center.y+offset);// [self pointFromAngle: self.angle size:handleInternalSize];
    
    //Create the path
    float handleRadius = handleInternalSize/2;
    
    CGContextSaveGState(ctx);
    [[UIColor colorWithRed:1 green:1 blue:1 alpha:0.4] set];
    CGContextAddArc(ctx, handleInternalCenter.x+handleRadius, handleInternalCenter.y+handleRadius+0.5, handleRadius, 0, ToRad(180), 0);
    CGContextSetLineWidth(ctx, 0.5);
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextRestoreGState(ctx);
    
    CGContextSaveGState(ctx);
    //CGContextSetShadowWithColor(ctx, CGSizeMake(2, 2), 3, [UIColor whiteColor].CGColor);
    [intColor set];
    CGContextFillEllipseInRect(ctx, CGRectMake(handleInternalCenter.x, handleInternalCenter.y, handleInternalSize, handleInternalSize));
    CGContextRestoreGState(ctx);

/*
    CGContextSaveGState(ctx);
    CGContextAddArc(ctx, centerPoint.x, centerPoint.y, handleSize/2, 0, M_PI*2, 0);
    CGContextSetStrokeColorWithColor(ctx, color.CGColor );
    //Define line width and cap
    CGContextSetLineWidth(ctx, 6);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    //draw it!
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextRestoreGState(ctx);
*/
}



-(void)drawText:(CGContextRef)ctx withValue:(NSString*)text withColor:(UIColor*)color at:(CGPoint)center {

    if (text!=nil) {
        CGContextSaveGState(ctx);
     
        CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
        CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
        CGContextScaleCTM(ctx, 1.0, -1.0);
        
        
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
        CFAttributedStringSetAttribute((__bridge CFMutableAttributedStringRef) attrString, CFRangeMake(0, attrString.length), kCTFontAttributeName, font);
        CFAttributedStringSetAttribute((__bridge CFMutableAttributedStringRef) attrString, CFRangeMake(0, attrString.length), kCTForegroundColorAttributeName, color.CGColor);
        
        
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString); //3
        
        CGSize textSize = [self sizeOfAttrString:framesetter];
        /*
        if (textSize.width>wheelBackgroundSize) {
            CFAttributedStringRemoveAttribute((__bridge CFMutableAttributedStringRef) attrString, CFRangeMake(0, attrString.length), kCTFontAttributeName);
            CFAttributedStringSetAttribute((__bridge CFMutableAttributedStringRef) attrString, CFRangeMake(0, attrString.length), kCTFontAttributeName, smallFont);
            framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
            textSize = [self sizeOfAttrString:framesetter];
        }
         */
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

/** Move the Handle **/
-(void)movehandle:(CGPoint)lastPoint{
    
    //Calculate the direction from a center point and a arbitrary position.
    float currentAngle = AngleFromNorth(centerPoint, lastPoint, NO);
    
    
    int angleInt = round(currentAngle);
    int temp_angle = 360 - angleInt;
    
    
    //Store the new angle
    angle = temp_angle;

    
    [self updateValue:angle];
    
    handleCenter =  [self pointFromAngle:angle size:handleSize];
    
    //Redraw
    [self setNeedsDisplay];
    // }
    
}

-(void)updateValue:(int)newAngle {
    BOOL update = true;
    
    //CHECK COMPLETE LOOP
    if ( (lastAngle>90 && lastAngle<=180) && (newAngle>=0 && newAngle<=90) ) {
        if (halfCompleted) {
            halfCompleted = false;
            wheelLoop++;
            if (wheelLoop>100) wheelLoop=100;
        }
    }
    else
        if ( (newAngle>90 && newAngle<=180) && (lastAngle>=0 && lastAngle<=90) ) {
                wheelLoop--;
                halfCompleted = true;
                if (wheelLoop<0) {
                    halfCompleted = false;
                    wheelLoop=0;
                    newAngle = 90;
                    angle = 90;
                    lastAngle = 89;
                    update = false;
                }
        }
        else
            if (newAngle>=240 && newAngle<=320) {
                halfCompleted = true;
            }

    

    if (update) {
        lastAngle = newAngle;
    }
 
}


#pragma mark - Math -

/** Move the Handle **/
-(int)angleAtPoint:(CGPoint)lastPoint{
    
    //Calculate the direction from a center point and a arbitrary position.
    float currentAngle = AngleFromNorth(centerPoint, lastPoint, NO);
    
    int angleInt = round(currentAngle);
    int temp_angle = 360 - angleInt;


    return temp_angle;
}

/** Given the angle, get the point position on circumference **/
-(CGPoint)pointFromAngle:(int)angleInt size:(CGFloat)size {
    
    //Circle center
    CGPoint center = CGPointMake(centerPoint.x - size/2, centerPoint.y - size/2);
    
    //The point position on the circumference
    CGPoint result;
    result.y = round(center.y + radius * sin(ToRad(-angleInt))) ;
    result.x = round(center.x + radius * cos(ToRad(-angleInt)));
    
    return result;
}

-(float)getCurrentValue {
    float current = 0;
    
    current = wheelLoop * stepValue;
    if (angle>0) {
        int temp_angle = 0;
        if (angle>=0 && angle<=90) {
             temp_angle = 90-angle;
        }
        else {
            //if (wheelLoop>0)
                temp_angle = 90+(360-angle);
        }
        
        float diffValue = stepValue * ((float)temp_angle/(float)360);
        current += diffValue;
    }
    
    
    return current;
}

-(float)valueFromAngle:(int)handleAngle {
    float current = 0;
    
    int ngiri = handleAngle / 360;
    current = ngiri * stepValue;
    int diffAngle = handleAngle - (ngiri * 360);
    if (diffAngle>0) {
        float diffValue = stepValue * (diffAngle/360);
        current += diffValue;
    }
    
    return current;

}

-(int)handleAngleWithValue:(float)value {
    if (value>=startValue && value<=endValue ) {
        
        wheelLoop = value / stepValue;
        
        int handleAngle = 360 * (value / stepValue);
        if (wheelLoop>0) {
            handleAngle = handleAngle - (360*wheelLoop);
        }
        
        //normalize
        if (handleAngle>=0 && handleAngle<=90)
            handleAngle = 90 - handleAngle;
        else
            handleAngle = 360 - (handleAngle - 90);
        
        if (handleAngle>=90 && handleAngle<=270)
            halfCompleted = true;
        
        return handleAngle;
    }
    
    return 0;
}

-(float)getCurrentValueWithIncrement:(BOOL)incr {
    float currentValue = [self getCurrentValue];
    if (incr && increment>0) {
        currentValue = floor(currentValue/increment)*increment;
    }
    
    //NSLog(@"angle=%i",current);
    return currentValue;
}


-(void)setCurrentValue:(float)value {
    angle = [self handleAngleWithValue:value];
    handleCenter =  [self pointFromAngle: angle size:handleSize];
    lastAngle = angle;

    
}




-(void)setupUnitWithStart:(float)start withEnd:(float)end withDefault:(float)def withStep:(float)step withCenterText:(NSString*)text {
    startValue = start;
    endValue = end;
    stepValue = step;
    defaultValue = def;
    centerText = text;
    isSliding = false;
    isHandleTouched = FALSE;
    wheelLoop = 0;
    lastAngle = 90;
    angle = 90;
    [self setCurrentValue:def];
    
}



//Sourcecode from Apple example clockControl 
//Calculate the direction in degrees from a center point to an arbitrary position.
static inline float AngleFromNorth(CGPoint p1, CGPoint p2, BOOL flipped) {
    CGPoint v = CGPointMake(p2.x-p1.x,p2.y-p1.y);
    float vmag = sqrt(SQR(v.x) + SQR(v.y)), result = 0;
    v.x /= vmag;
    v.y /= vmag;
    double radians = atan2(v.y,v.x);
    result = ToDeg(radians);
    return (result >=0  ? result : result + 360.0);
}

- (CGSize) sizeOfAttrString:(CTFramesetterRef)framesetter
{
    return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(0, CGFLOAT_MAX), NULL);
}

-(BOOL)isSliding {
    return isSliding;
}

-(void)dealloc {
    CFRelease(font);
    CFRelease(smallFont);
}

@end


