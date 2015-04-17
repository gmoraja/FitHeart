//
//  FTEntriesGraph.m
//  FitHeart
//
//  Created by Bitgears on 05/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//
#import <CoreText/CoreText.h>
#import "FTEntriesGraph.h"
#import "FTLogGroupedData.h"
#import "UCFSUtil.h"

#define ToRad(deg) 		( (M_PI * (deg)) / 180.0 )

static float MIN_BAR_HEIGHT = 5;
static float TEXT_OFFSET_Y = 28;

@interface FTEntriesGraph() {
    float barPadding;
    float barWidth;
    float barOffsetX;
    int numVisibleBars;
    

    UIColor* maskBarColor;
    
    float center;
    float lastPositionX;
    CGPoint startTouchPoint;
    
    UIImage *goalValueImage;
    CGPoint goalValueImagePoint;
    
    UIImage *topFixImage;
    UIImage *topFixNonTappableImage;
    
    CTFontRef font;
    CTFontRef smallFont;
    
    CGRect selectedBarRect;
    
    BOOL isSliding;

}

@end

@implementation FTEntriesGraph 

@synthesize items;
@synthesize selectedIndex;
@synthesize goalValueImageVisible;
@synthesize goalValue;
@synthesize maxValue;
@synthesize formatValueAsFloat;
@synthesize formatValueAsCompact;
@synthesize delegate;
@synthesize bar2Color;
@synthesize barColor;
@synthesize bar2OverflowColor;
@synthesize barOverflowColor;
@synthesize isTappable;
@synthesize clipInElipse;

- (id)initWithFrame:(CGRect)frame withBarWidth:(float)barwidth withMaxLimitImage:(NSString*)maxLimitImageFile withTopFixImage:(NSString*)topFixImageFile withTopFixNonTappableImage:(NSString*)topFixNonTappableImageFile {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        clipInElipse = NO;
        self.opaque = NO;
        lastPositionX = 0;
        barPadding = 6;
        barOffsetX = -8;
        barWidth = barwidth;
        barColor = [UIColor lightGrayColor];
        bar2Color = [UIColor grayColor];
        numVisibleBars = trunc(frame.size.width / (barWidth+barPadding));
        goalValueImage = [UIImage imageNamed:maxLimitImageFile];
        topFixImage = [UIImage imageNamed:topFixImageFile];
        topFixNonTappableImage = [UIImage imageNamed:topFixNonTappableImageFile];
        isSliding = false;
        goalValueImageVisible = false;
        formatValueAsFloat = FALSE;
        formatValueAsCompact = FALSE;
        isTappable = TRUE;
        
        font = CTFontCreateWithName((CFStringRef)@"SourceSansPro-Regular", 20.0f, nil);
        smallFont = CTFontCreateWithName((CFStringRef)@"SourceSansPro-Regular", 16.0f, nil);

        
    }
    return self;
}

- (void)resetWithEntries:(NSMutableArray*)entries valueAsFloat:(BOOL)isFloat valueAsCompact:(BOOL)isCompact {
    items = entries;
    selectedIndex = 0;
    lastPositionX = 0;
    formatValueAsFloat = isFloat;
    formatValueAsCompact = isCompact;
    isTappable = NO;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
     // Drawing code
     [super drawRect:rect];
     
     CGContextRef ctx = UIGraphicsGetCurrentContext();
 
     //[self drawRectangle:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) withContext:ctx withColor:[UIColor redColor]];
     if (clipInElipse) {
         CGRect ellipseRect = CGRectMake(1, (self.frame.size.height-self.frame.size.width)/2+1, self.frame.size.width-2, self.frame.size.width-2);
         CGContextBeginPath(ctx);
         CGContextAddEllipseInRect(ctx, ellipseRect);
         CGContextClosePath(ctx);
         CGContextClip(ctx);
     }
     else {
         CGRect rect = CGRectMake(0, 0, self.frame.size.width-67, self.frame.size.height);
         CGContextBeginPath(ctx);
         CGContextAddRect(ctx, rect);
         CGContextClosePath(ctx);
         CGContextClip(ctx);
     }

     
     if (goalValueImageVisible) {
         goalValueImagePoint = CGPointMake(0, (self.frame.size.height*0.3)-1);
         [goalValueImage drawAtPoint:goalValueImagePoint];
     }
     
     [self drawVisibleBars:ctx];

     

 }


- (CGRect)barWithValue:(float)value withMaxValue:(int)maxvalue atX:(float)bar_x withMinBarHeight:(float)minHeight withMaxBarHeight:(float)maxHeight {
    float barHeight = 0;
    if (value>0) {
        if (value>maxvalue) {
            barHeight = self.frame.size.height-TEXT_OFFSET_Y;
        }
        else {
            barHeight = (value*self.frame.size.height)/maxvalue;
            if (barHeight>(self.frame.size.height-TEXT_OFFSET_Y) )
                barHeight = self.frame.size.height-TEXT_OFFSET_Y;
            //else
            //barHeight = barHeight-TEXT_OFFSET_Y;
        }
        
        
        if (barHeight>maxHeight && maxHeight>0)
            barHeight = maxHeight;
        
        if (barHeight<minHeight)
            barHeight = minHeight;
    }
    else {
        barHeight = minHeight;
    }
    float bar_y = self.frame.size.height-barHeight-4;
    return CGRectMake(bar_x, bar_y, barWidth, barHeight);
}

- (void)drawVisibleBars:(CGContextRef)ctx {
    
    float offsetX = ( (int)(abs(lastPositionX)) % (int)(barWidth+barPadding) )-8;
    int sideBars = trunc(numVisibleBars / 2);
    int currentIndex = ( abs(lastPositionX) / (barWidth+barPadding) );
    int firstIndex = currentIndex-sideBars;
    int lastIndex = currentIndex+sideBars;
    //int firstIndex = selectedIndex-sideBars;
    //int lastIndex = selectedIndex+sideBars;
    //NSLog(@"%i<-%i->%i", lastIndex, selectedIndex, firstIndex);
    if (firstIndex<0) firstIndex = 0;
    
    //float bar_x = 0;
    //float bar_y = 0;
    float minBarHeight = 5;
    float minBar2Height = 2;
    int index = 0;
    BOOL selected = false;
    for (int i=lastIndex; i>=firstIndex; i--) {
        if (i>=0 && i<[items count]) {
            float bar_x = (index * (barWidth+barPadding))+offsetX;//barOffsetX;

            FTLogGroupedData* item = (FTLogGroupedData*)([items objectAtIndex:i]);
            selected = (i==selectedIndex);
            
            if (item.value2>0) {
                minBarHeight = MIN_BAR_HEIGHT * 2;
                minBar2Height = MIN_BAR_HEIGHT;
            }
            else {
                minBarHeight = 5;
                minBar2Height = 2;
            }
            
            CGRect barRect = [self barWithValue:item.value withMaxValue:maxValue atX:bar_x withMinBarHeight:minBarHeight withMaxBarHeight:self.frame.size.height];
            CGRect bar2Rect;
            if (goalValue>0)
                 bar2Rect = [self barWithValue:item.value2 withMaxValue:maxValue atX:bar_x withMinBarHeight:minBar2Height withMaxBarHeight:barRect.size.height-20];
            else
                 bar2Rect = [self barWithValue:item.value2 withMaxValue:item.value atX:bar_x withMinBarHeight:minBar2Height withMaxBarHeight:barRect.size.height-20];
            
            
            if (item.value>=goalValue && goalValueImageVisible) {
                [self drawBarWithFrame:barRect withContext:ctx withColor:barOverflowColor withTextColor:barOverflowColor withValueLabel:item.value asSelected:selected];
                [self drawBarWithFrame:bar2Rect withContext:ctx withColor:bar2OverflowColor withTextColor:bar2OverflowColor withValueLabel:item.value2 asSelected:selected];
            }
            else {
                [self drawBarWithFrame:barRect withContext:ctx withColor:barColor withTextColor:barColor withValueLabel:item.value asSelected:selected];
                [self drawBarWithFrame:bar2Rect withContext:ctx withColor:bar2Color withTextColor:bar2Color withValueLabel:item.value2 asSelected:selected];
            }
            
        }
        index++;
    }
    
}


-(void)drawBarWithFrame:(CGRect)frame withContext:(CGContextRef)ctx withColor:(UIColor*)color withTextColor:(UIColor*)textColor withValueLabel:(float)value asSelected:(BOOL)isSelected {
    
    if (value>goalValue && goalValueImageVisible) {
        NSString* text = [UCFSUtil stringWithValue:value formatAsFloat:formatValueAsFloat formatAsCompact:formatValueAsCompact];

        //draw top fix
        if (value>maxValue) {
            [self drawTopFixImage:ctx atX:frame.origin.x atY:frame.size.height+5];
            CGRect belowBarRect = CGRectMake(frame.origin.x, frame.origin.y+topFixImage.size.height-5, frame.size.width, frame.size.height-topFixImage.size.height+5);
            [self drawRectangle:belowBarRect withContext:ctx withColor:color];
            if (isSelected) {
                //draw background text
                CGRect textBkgRect = CGRectMake(frame.origin.x, 4, frame.size.width, TEXT_OFFSET_Y-12);
                [self drawRectangle:textBkgRect withContext:ctx withColor:[UIColor whiteColor]];
            }
            //draw text
            [self drawTheInfo:ctx withText:text withColor:textColor atX:frame.origin.x atY:frame.size.height+TEXT_OFFSET_Y];
        }
        else {
            float barHeight = frame.size.height;
            
            CGRect belowBarRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, barHeight);
            [self drawRectangle:belowBarRect withContext:ctx withColor:color];
            if (isSelected) {
                //draw background text
                CGRect textBkgRect = CGRectMake(frame.origin.x, frame.origin.y-TEXT_OFFSET_Y+8, frame.size.width, TEXT_OFFSET_Y-12);
                [self drawRectangle:textBkgRect withContext:ctx withColor:[UIColor whiteColor]];
            }
            //draw text
            [self drawTheInfo:ctx withText:text withColor:textColor atX:frame.origin.x atY:frame.size.height+TEXT_OFFSET_Y];
        }
    }
    else {
        //[self drawRectangle:frame withContext:ctx withColor:color];
        [self drawRectangle:frame withContext:ctx withColor:color];
        //text
        if (value>0) {
            NSString* text = [UCFSUtil stringWithValue:value formatAsFloat:formatValueAsFloat formatAsCompact:formatValueAsCompact];
            if (isSelected) {
                //draw background text
                CGRect textBkgRect = CGRectMake(frame.origin.x, frame.origin.y-TEXT_OFFSET_Y+8, frame.size.width, TEXT_OFFSET_Y-12);
                [self drawRectangle:textBkgRect withContext:ctx withColor:[UIColor whiteColor]];
            }
            //draw text
            [self drawTheInfo:ctx withText:text withColor:textColor atX:frame.origin.x atY:frame.size.height+TEXT_OFFSET_Y];
            
        }
    }

}


-(void)drawDottedLine:(CGContextRef)ctx {
    float dotRadius = 4;
    CGFloat lengths[2];
    lengths[0] = 0;
    lengths[1] = dotRadius * 2;
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx, dotRadius);
    CGContextSetLineDash(ctx, 0.0f, lengths, 2);
}

- (void)drawRectangle:(CGRect)rect withContext:(CGContextRef)context withColor:(UIColor*)color {
    
    CGContextAddRect(context, rect);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);

}

-(void)drawTopFixImage:(CGContextRef)ctx atX:(float)x atY:(float)y  {
    CGContextSaveGState(ctx);
    
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextDrawImage(ctx, CGRectMake(x, y-topFixImage.size.height, topFixImage.size.width, topFixImage.size.height), topFixImage.CGImage);
    CGContextRestoreGState(ctx);
}

/** Draw a white circle at start and end **/
-(void) drawTheInfo:(CGContextRef)ctx withText:(NSString*)text withColor:(UIColor*)color atX:(float)x atY:(float)y {
    
    CGContextSaveGState(ctx);
    
    CGContextSetTextMatrix(ctx, CGAffineTransformIdentity);
    CGContextTranslateCTM(ctx, 0, self.bounds.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    //TEXT
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    CFAttributedStringSetAttribute((__bridge CFMutableAttributedStringRef) attrString, CFRangeMake(0, attrString.length), kCTFontAttributeName, font);
    CFAttributedStringSetAttribute((__bridge CFMutableAttributedStringRef) attrString, CFRangeMake(0, attrString.length), kCTForegroundColorAttributeName, color.CGColor);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString); //3
    
    CGSize textSize = [self sizeOfAttrString:framesetter];
    if (textSize.width>barWidth) {
        CFAttributedStringRemoveAttribute((__bridge CFMutableAttributedStringRef) attrString, CFRangeMake(0, attrString.length), kCTFontAttributeName);
        CFAttributedStringSetAttribute((__bridge CFMutableAttributedStringRef) attrString, CFRangeMake(0, attrString.length), kCTFontAttributeName, smallFont);
        framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
        textSize = [self sizeOfAttrString:framesetter];
    }

    CGMutablePathRef path = CGPathCreateMutable();

    float yy = y-textSize.height;
    if (y<10) {
        yy = 10;
    }

    CGPathAddRect(path, NULL, CGRectMake(x + (barWidth/2) - (textSize.width/2), yy, textSize.width, textSize.height) );
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attrString length]), path, NULL);
    
    CTFrameDraw(frame, ctx);
    
    CGContextRestoreGState(ctx);
    
    CGPathRelease(path);
    CFRelease(frame);
    CFRelease(framesetter);
}

- (CGSize) sizeOfAttrString:(CTFramesetterRef)framesetter
{
    return CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(0, CGFLOAT_MAX), NULL);
}




/** Tracking is started **/
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super beginTrackingWithTouch:touch withEvent:event];
    startTouchPoint = [touch locationInView:self];
    lastPositionX =  - (selectedIndex * (barWidth+barPadding));

    return YES;
}

/** Track continuos touch event (like drag) **/
-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super continueTrackingWithTouch:touch withEvent:event];
    CGPoint lastPoint = [touch locationInView:self];
    lastPositionX += (startTouchPoint.x - lastPoint.x)*0.5;
    if (lastPositionX>0) lastPositionX = 0;
    startTouchPoint = lastPoint;
    
   
    if (lastPositionX>0)
        lastPositionX = 0;
    
    selectedIndex = abs((lastPositionX-(barWidth/2)) / (barWidth+barPadding) );
    barOffsetX = abs(round((int)lastPositionX % (int)(barWidth+barPadding) ))-8;
    if (selectedIndex>([items count]-1))
        selectedIndex = [items count]-1;
    
    //Redraw
    [self setNeedsDisplay];
    
    //NSLog(@"pos=%i",selectedIndex);
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];

    isSliding = YES;
    
    return YES;
}

/** Track is finished **/
-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [super endTrackingWithTouch:touch withEvent:event];
 
    //check tap selected bar
    CGPoint lastPoint = [touch locationInView:self];
    if (
            (lastPoint.x>selectedBarRect.origin.x && lastPoint.x<(selectedBarRect.origin.x+selectedBarRect.size.width)) &&
            (lastPoint.y>selectedBarRect.origin.y && lastPoint.y<(selectedBarRect.origin.y+selectedBarRect.size.height)) &&
            (isSliding == NO)
        ) {
        if (isTappable && delegate)
            [self.delegate onTappedSelectedEntry];
    }
    
    isSliding = NO;

    
}

-(void)dealloc {
    items = nil;
    CFRelease(font);
    CFRelease(smallFont);
}



@end
