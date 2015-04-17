//
//  GoalSingleHeaderView.m
//  FitHeart
//
//  Created by Bitgears on 12/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//


#import "FTSingleHeaderView.h"
#import "FTHeaderView.h"



@interface FTSingleHeaderView() {

}

@end

@implementation FTSingleHeaderView




- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withConf:(FTHeaderConf*)headerConf {
    arrowType = 2;
    self = [super initWithFrame:frame withConf:headerConf];
    if (self) {
        // Initialization code
        [self initValueUI];
        
        [self editMode:NO withValueIndex:0];
    }
    return self;
}

- (void)initValueUI {

    float offset_x = (self.frame.size.width-conf.valueTextWidth)/2;
    float offset_y = (self.frame.size.height-valueTextHeight)/2;
    CGRect valueFrame = CGRectMake(offset_x, offset_y, conf.valueTextWidth, valueTextHeight);
    
    valueLabel = [[UILabel alloc] initWithFrame:valueFrame];
    valueLabel.textColor = conf.valueTextColor;
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:(52.0)];
    valueLabel.textAlignment =  ALIGN_CENTER;
    valueLabel.adjustsFontSizeToFitWidth = true;
    valueLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    valueLabel.numberOfLines = 1;
    valueLabel.text = @"100";
    [valueLabel setAccessibilityHint:@"Tap to enable value"];
    [valueLabel setAccessibilityValue:[NSString stringWithFormat:@"100 %@", conf.unit ]];
    
    valueText = [[UITextField alloc] initWithFrame:valueFrame];
    valueText.borderStyle = UITextBorderStyleNone;
    valueText.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:(52.0)];
    valueText.textColor = conf.valueTextColor;
    valueText.autocorrectionType = UITextAutocorrectionTypeNo;
    if (conf.valueIsFloat)
        valueText.keyboardType = UIKeyboardTypeDecimalPad;
    else
        valueText.keyboardType = UIKeyboardTypeNumberPad;
    
    valueText.returnKeyType = UIReturnKeyDone;
    valueText.clearButtonMode = UITextFieldViewModeNever;
    valueText.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    valueText.textAlignment = ALIGN_CENTER;
    valueText.adjustsFontSizeToFitWidth = true;
    valueText.minimumFontSize = 17.0;
    valueText.text = @"100";
    valueText.tag = 0;
    [valueText setAccessibilityValue:[NSString stringWithFormat:@"100 %@", conf.unit ]];
    
    pencilImageView.frame = CGRectMake( self.frame.size.width-pencilImageView.frame.size.width-10 , (self.frame.size.height-pencilImageView.frame.size.height)/2, pencilImageView.frame.size.width, pencilImageView.frame.size.height);

    [self addSubview:pencilImageView];
    [self addSubview:valueLabel];
    [self addSubview:valueText];
}





-(void)editMode:(BOOL)edit  withValueIndex:(int)activeValue {
    [super editMode:edit withValueIndex:activeValue];
    
    valueLabel.hidden = edit;
    valueText.hidden = !edit;

}

-(void)showPencil:(BOOL)show withValueIndex:(int)activeValue {
    if (activeValue==0)
        pencilImageView.hidden = !show;
}





@end
