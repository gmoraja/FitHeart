//
//  FTTimerHeaderView.h
//  FitHeart
//
//  Created by Bitgears on 13/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTHeaderView.h"
#import "FTHeaderConf.h"

@interface FTTimerHeaderView : FTHeaderView {
    
    float leftLabelWidth;
    UIView* containerView;
    
    UILabel *valueMinuteLabel;
    UITextField *valueMinuteText;
    UILabel *minuteLabel;

    UILabel *valueSecondsLabel;
    UITextField *valueSecondsText;
    UILabel *secondsLabel;
}

@property (strong,nonatomic) UILabel *valueMinuteLabel;
@property (strong,nonatomic) UITextField *valueMinuteText;
@property (strong,nonatomic) UILabel *minuteLabel;

@property (strong,nonatomic) UILabel *valueSecondsLabel;
@property (strong,nonatomic) UITextField *valueSecondsText;
@property (strong,nonatomic) UILabel *secondsLabel;

- (id)initWithFrame:(CGRect)frame withConf:(FTHeaderConf*)headerConf;
-(void)showHideSeconds:(BOOL)show;
-(void)showHideHours:(BOOL)show;
-(void)updateHeaderWithTime:(int)time;
- (void)updateUIWithHours:(int)hours withMinutes:(int)minutes withSeconds:(int)seconds;

@end
