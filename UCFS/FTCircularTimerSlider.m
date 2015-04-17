//
//  FTCircularTimerSlider.m
//  FitHeart
//
//  Created by Bitgears on 06/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "FTCircularTimerSlider.h"
#import <CoreText/CoreText.h>

/** Helper Functions **/
#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )
#define ToDeg(rad)		( (180.0 * (rad)) / M_PI )
#define SQR(x)			( (x) * (x) )


@interface FTCircularTimerSlider(){
    UIImage *guideImage;
    CGPoint guideImagePoint;
    CGPoint startInfoCenter;
    CGPoint endInfoCenter;
    CGRect endInfoRect;
    int lastMinutes;
    bool canMove;
    bool canIncr;
    bool canDecr;
    UIColor* automaticProgressGuideColor;
    float radius;
    BOOL isSliding;
    UIColor *shadowColor;
    
}
@end

@implementation FTCircularTimerSlider

@synthesize wheelRadius;
@synthesize wheelBackgroundColor;
@synthesize wheelBackgroundSize;
@synthesize guideBackgroundColor;
@synthesize guideForegroundColor;
@synthesize guideSize;
@synthesize hourBarRadius;
@synthesize hourBarBackgroundColor;
@synthesize hourBarForegroundColor;
@synthesize hourBarSize;
@synthesize handleColor;
@synthesize handleSize;
@synthesize handleInternalColor;
@synthesize handleInternalSize;
@synthesize minutes;
@synthesize hours;
@synthesize isManual;

-(id)initWithFrame:(CGRect)frame withRadius:(float)wheelradius withSize:(float)size {
    
    self = [super initWithFrame:frame];
    
    if(self){
        self.opaque = NO;
        isSliding = false;
        wheelRadius = wheelradius;
        wheelBackgroundSize = size;
        radius = wheelRadius-(wheelBackgroundSize/2);

        guideImage = [UIImage imageNamed:@"circular_timer_slider_guide.png"];
        float bkgX = (frame.size.width - guideImage.size.width) / 2;
        float bkgY = (frame.size.height - guideImage.size.height) / 2;;
        guideImagePoint = CGPointMake(bkgX, bkgY);
        
        minutes = 0;
        hours = 0;
        lastMinutes = 0;
        self.angle = (minutes*6)+90;
        canIncr = true;
        canDecr = false;
        isManual= true;
        automaticProgressGuideColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
        shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    }
    
    return self;
}


/** Tracking is started **/
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    
    //Get touch location
    CGPoint touchPoint = [touch locationInView:self];
    //get handle location
    CGPoint handleCenter =  [self pointFromAngle: self.angle size:handleSize];
    //check
    if (
            ( touchPoint.x>=handleCenter.x && touchPoint.x<=(handleCenter.x+handleSize) ) &&
            ( touchPoint.y>=handleCenter.y && touchPoint.y<=(handleCenter.y+handleSize) )
        )
        return YES;
    else
        return NO;
}

/** Track continuos touch event (like drag) **/
-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    
    if (isManual) {
        //Get touch location
        CGPoint lastPoint = [touch locationInView:self];
        //Use the location to design the Handle
        [self movehandle:lastPoint];
        //Control value has changed, let's notify that
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        
        isSliding = YES;
    }
    
    return YES;
}

/** Track is finished **/
-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
    isSliding = NO;
}


//Use the draw rect to draw the Background, the Circle and the Handle
-(void)drawRect:(CGRect)rect{
    
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    
    /** BACKGROUND **/
    CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, radius, 0, 2*M_PI, 0);
    CGContextSetStrokeColorWithColor(ctx, wheelBackgroundColor.CGColor );
    //Define line width and cap
    CGContextSetLineWidth(ctx, wheelBackgroundSize);
    CGContextSetLineCap(ctx, kCGLineCapButt);
    //draw it!
    CGContextDrawPath(ctx, kCGPathStroke);
    
    if (isManual) {
        /** GUIDE BACKGROUND BORDER **/

        [guideImage drawAtPoint:guideImagePoint];
        /*
        CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
        CGFloat comps[] = { 185.0/255.0, 185.0/255.0, 185.0/255.0, 0.6,
            255.0/255.0, 255.0/255.0, 255.0/255.0, 0.6};
        CGPoint center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        CGFloat locs_inner[] = {0,1};
        CGGradientRef gradient_inner = CGGradientCreateWithColorComponents(space, comps, locs_inner, 2);
        CGContextDrawRadialGradient(ctx, gradient_inner, center, radius-(guideSize/2), center, radius, 0);
        CGGradientRelease(gradient_inner);
        CGGradientRef gradient_outer = CGGradientCreateWithColorComponents(space, comps, locs_inner, 2);
        CGContextDrawRadialGradient(ctx, gradient_outer, center, radius+(guideSize/2), center, radius, 0);
        CGGradientRelease(gradient_outer);
         */
        
        /** GUIDE FOREGROUND **/
        CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, radius, -ToRad(90), -ToRad(self.angle), 0);
        //Set the stroke color to black
        [guideForegroundColor setStroke];
        //Define line width and cap
        CGContextSetLineWidth(ctx, guideSize);
        CGContextSetLineCap(ctx, kCGLineCapButt);
        //draw it!
        CGContextDrawPath(ctx, kCGPathStroke);
        
        //*GUIDE PLACEHOLDE **/
        CGContextSaveGState(ctx);
        CGPoint handleCenter =  [self pointFromAngle: 90 size:handleSize];
        [guideForegroundColor set];
        CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, wheelBackgroundSize, wheelBackgroundSize));
        CGContextRestoreGState(ctx);
        
        
        [self drawTheHandle:ctx];
    }
    else {
        /** PROGRESS **/
        CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, radius, -ToRad(90), -ToRad(self.angle), 0);
        CGContextSetStrokeColorWithColor(ctx, handleColor.CGColor );
        //Define line width and cap
        CGContextSetLineWidth(ctx, wheelBackgroundSize);
        CGContextSetLineCap(ctx, kCGLineCapButt);
        //draw it!
        CGContextDrawPath(ctx, kCGPathStroke);
        
        /** GUIDE FOREGROUND **/
        CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, radius, 0, 2*M_PI, 0);
        //Set the stroke color to black
        [automaticProgressGuideColor setStroke];
        //Define line width and cap
        CGContextSetLineWidth(ctx, 4);
        CGContextSetLineCap(ctx, kCGLineCapButt);
        //draw it!
        CGContextDrawPath(ctx, kCGPathStroke);

        
    }
    
    //HOUR
    float radiusHours = hourBarRadius-(hourBarSize/2);
    float angleBar = (2*M_PI / 9);
    for (int i = 0; i < 9; i++) {
        CGContextAddArc(ctx, self.frame.size.width/2, self.frame.size.height/2, radiusHours, -ToRad(90)+(i*angleBar), -ToRad(90)+(i+1)*angleBar-0.1, 0);
        if (i>(hours-1))
            CGContextSetStrokeColorWithColor(ctx, hourBarBackgroundColor.CGColor );
        else
            CGContextSetStrokeColorWithColor(ctx, hourBarForegroundColor.CGColor );
        //Define line width and cap
        CGContextSetLineWidth(ctx, hourBarSize);
        CGContextSetLineCap(ctx, kCGLineCapButt);
        //draw it!
        CGContextDrawPath(ctx, kCGPathStroke);
    }
    
    if (isManual==NO) {
        
        //MINUTE LINE
        CGContextSetLineWidth(ctx, 1.0);
        CGContextSetStrokeColorWithColor(ctx, [UIColor lightGrayColor].CGColor);

        CGContextMoveToPoint(ctx, self.frame.size.width/2, self.frame.size.height/2);
        CGContextAddLineToPoint(ctx, self.frame.size.width/2, self.frame.size.height/2-radius-wheelBackgroundSize/2);
        CGContextStrokePath(ctx);
        CGPoint destPoint =  [self pointFromAngle: self.angle size:0];
        CGContextMoveToPoint(ctx, self.frame.size.width/2, self.frame.size.height/2);
        CGContextAddLineToPoint(ctx, destPoint.x, destPoint.y);
        CGContextStrokePath(ctx);
    }
 
}

/** Draw a white knob over the circle **/
-(void) drawTheHandle:(CGContextRef)ctx{

    
    CGContextSaveGState(ctx);
    CGPoint handleCenter =  [self pointFromAngle: self.angle size:handleSize];
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 4, shadowColor.CGColor);
    [handleColor set];
    CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, handleSize, handleSize));
    CGContextRestoreGState(ctx);
    
    CGPoint handleInternalCenter = CGPointMake(handleCenter.x+6.5, handleCenter.y+6.5);// [self pointFromAngle: self.angle size:handleInternalSize];
    
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
    [handleInternalColor set];
    CGContextFillEllipseInRect(ctx, CGRectMake(handleInternalCenter.x, handleInternalCenter.y, handleInternalSize, handleInternalSize));
    CGContextRestoreGState(ctx);
}


/** Move the Handle **/
-(void)movehandle:(CGPoint)lastPoint{
    
    //Get the center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    
    //Calculate the direction from a center point and a arbitrary position.
    float currentAngle = AngleFromNorth(centerPoint, lastPoint, NO);
    
    
    int angleInt = round(currentAngle);
    int temp_angle = 360 - angleInt;
    

    //Store the new angle
    self.angle = temp_angle;
    [self updateTime:self.angle];

    
    //Redraw
    [self setNeedsDisplay];
    // }
    
}

-(int)getCurrentHour {
    return hours;
}

-(int)getCurrentMinutes {
    return minutes;
}

-(void)setCurrentHour:(int)hour {
    hours = hour;

}

-(void)setCurrentMinutes:(int)min {
    minutes = min;
    lastMinutes = min;
    self.angle = ((60-minutes)*6)+90;
}

-(void)updateTime:(int)angle {
    if (angle>=0 && angle<=90) {
        minutes = round( 15.0 - (angle/6) );
    }
    else {
        minutes = round( 15 + ((360-angle)/6) );
    }

    //CHECK LIMIT
    if (hours==0) {
        if ( (minutes<=59 && minutes>=31) && (lastMinutes>=0 && lastMinutes<=10)) {
            self.angle = 90;
            minutes= 0;
            lastMinutes = 0;
        }
    }
    else
        if (hours==9) {
            if ( (lastMinutes<=59 && lastMinutes>=50) && (minutes>=0 && minutes<=30)) {
                self.angle = 91;
                minutes= 59;
                lastMinutes = 58;
            }
        }

    //CHECK COMPLETE LOOP
    if ( (lastMinutes<=59 && lastMinutes>=50) && (minutes>=0 && minutes<=10)) {
        if (canIncr) {
            hours++;
            if (hours>9) hours=9;
            canIncr = false;
        }

    }
    else
        if ( (minutes<=59 && minutes>=50) && (lastMinutes>=0 && lastMinutes<=10)) {
            if (canDecr) {
                hours--;
                if (hours<0) hours=0;
                canDecr = false;
            }
        }
        else {
            canIncr = true;
            canDecr = true;
        }

    
    lastMinutes = minutes;
}


/** Given the angle, get the point position on circumference **/
-(CGPoint)pointFromAngle:(int)angleInt size:(CGFloat)size {
    
    //Circle center
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2 - size/2, self.frame.size.height/2 - size/2);
    
    //The point position on the circumference

    CGPoint result;
    result.y = round(centerPoint.y + radius * sin(ToRad(-angleInt))) ;
    result.x = round(centerPoint.x + radius * cos(ToRad(-angleInt)));
    
    return result;
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

-(void)setAsManual {
    isManual = YES;
}

-(void)setAsAutomatic {
    isManual = NO;
}

-(BOOL)isSliding {
    return isSliding;
}



@end
