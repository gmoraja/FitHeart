//
//  TBCircularSlider.h
//  TB_CircularSlider
//
//  Created by Yari Dareglia on 1/12/13.
//  Copyright (c) 2013 Yari Dareglia. All rights reserved.
//

#import <UIKit/UIKit.h>

/** Parameters **/
#define TB_LINE_WIDTH 10                            //The width of the active area (the gradient) and the width of the handle
#define TB_FONTSIZE 65                              //The size of the textfield font
#define TB_FONTFAMILY @"Futura-CondensedExtraBold"  //The font family of the textfield font
#define M_PI_8      0.39269908169872  /* pi/4           */

@protocol TBCircularSliderDelegate
- (void)tappedMaxValue;
@end


@interface TBCircularSlider : UIControl
    @property (nonatomic,assign) CGFloat wheelRadius;
    @property (strong, nonatomic) UIColor* wheelBackgroundColor;
    @property (nonatomic,assign) CGFloat wheelBackgroundSize;
    @property (strong, nonatomic) UIColor* guideBackgroundColor;
    @property (strong, nonatomic) UIColor* guideForegroundColor;
    @property (nonatomic,assign) CGFloat guideSize;
    @property (strong, nonatomic) UIColor* handleColor;
    @property (nonatomic,assign) CGFloat handleSize;
    @property (strong, nonatomic) UIColor* handleInternalColor;
    @property (nonatomic,assign) CGFloat handleInternalSize;
    @property (nonatomic,assign) CGFloat startValue;
    @property (nonatomic,assign) CGFloat stepValue; //step value for a complete wheel
    @property (nonatomic,assign) CGFloat defaultValue;
    @property (nonatomic,assign) CGFloat endValue;
    @property (nonatomic,assign) int increment;
    @property (weak) id <TBCircularSliderDelegate> delegate;

-(id)initWithFrame:(CGRect)frame withRadius:(float)wheelradius withSize:(float)size;
-(float)getCurrentValueWithIncrement:(BOOL)incr;
-(void)setCurrentValue:(float)value;
-(void)setupUnitWithStart:(float)start withEnd:(float)end withDefault:(float)def withStep:(float)step withCenterText:(NSString*)text;
-(BOOL)isSliding;

@end
