//
//  FTCircularTimerSlider.h
//  FitHeart
//
//  Created by Bitgears on 06/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTCircularTimerSlider : UIControl

@property (nonatomic,assign) int angle;
@property (nonatomic,assign) CGFloat wheelRadius;
@property (strong, nonatomic) UIColor* wheelBackgroundColor;
@property (nonatomic,assign) CGFloat wheelBackgroundSize;
@property (strong, nonatomic) UIColor* guideBackgroundColor;
@property (strong, nonatomic) UIColor* guideForegroundColor;
@property (nonatomic,assign) CGFloat guideSize;
@property (strong, nonatomic) UIColor* hourBarBackgroundColor;
@property (strong, nonatomic) UIColor* hourBarForegroundColor;
@property (nonatomic,assign) CGFloat hourBarSize;
@property (nonatomic,assign) CGFloat hourBarRadius;
@property (strong, nonatomic) UIColor* handleColor;
@property (nonatomic,assign) CGFloat handleSize;
@property (strong, nonatomic) UIColor* handleInternalColor;
@property (nonatomic,assign) CGFloat handleInternalSize;
@property (nonatomic,assign) int minutes;
@property (nonatomic,assign) int hours;
@property (nonatomic,assign) BOOL isManual;

-(id)initWithFrame:(CGRect)frame withRadius:(float)wheelradius withSize:(float)size;
-(void)setCurrentHour:(int)hour;
-(void)setCurrentMinutes:(int)min;
-(int)getCurrentHour;
-(int)getCurrentMinutes;
-(void)setAsManual;
-(void)setAsAutomatic;
-(BOOL)isSliding;

@end
