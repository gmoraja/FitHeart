//
//  FTDoubleHeaderView.m
//  FitHeart
//
//  Created by Bitgears on 11/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FTDoubleHeaderView.h"
#import "FTHeaderView.h"

@interface FTDoubleHeaderView() {


}

@end


@implementation FTDoubleHeaderView

@synthesize value2Label;
@synthesize value2Text;
@synthesize value2Unit;
@synthesize delegate;

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
    
    CGRect valueFrame = CGRectMake(0, 0, 160, self.frame.size.height);
    
    valueLabel = [[UILabel alloc] initWithFrame:valueFrame];
    valueLabel.textColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1];
    valueLabel.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1];
    valueLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:(52.0)];
    valueLabel.textAlignment =  ALIGN_CENTER;
    valueLabel.adjustsFontSizeToFitWidth = true;
    valueLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    valueLabel.numberOfLines = 1;
    valueLabel.text = @"100";
    valueLabel.userInteractionEnabled = YES;
    valueLabel.tag = 0;
    [valueLabel setAccessibilityHint:@"Double tap to enable text field."];
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
 
    
    
    CGRect value2Frame = CGRectMake(160, 0, 160, self.frame.size.height);
    
    value2Label = [[UILabel alloc] initWithFrame:value2Frame];
    value2Label.textColor = [UIColor colorWithRed:136.0/255.0 green:136.0/255.0 blue:136.0/255.0 alpha:1];
    value2Label.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1];
    value2Label.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:(52.0)];
    value2Label.textAlignment =  ALIGN_CENTER;
    value2Label.adjustsFontSizeToFitWidth = true;
    value2Label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    value2Label.numberOfLines = 1;
    value2Label.text = @"100";
    value2Label.tag = 1;
    value2Label.userInteractionEnabled = YES;
    [value2Label setAccessibilityHint:@"Double tap to enable text field."];
    [value2Label setAccessibilityValue:[NSString stringWithFormat:@"100 %@", conf.unit2 ]];
    
    value2Text = [[UITextField alloc] initWithFrame:value2Frame];
    value2Text.borderStyle = UITextBorderStyleNone;
    value2Text.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:(52.0)];
    value2Text.textColor = conf.valueTextColor;
    value2Text.autocorrectionType = UITextAutocorrectionTypeNo;
    if (conf.valueIsFloat)
        value2Text.keyboardType = UIKeyboardTypeDecimalPad;
    else
        value2Text.keyboardType = UIKeyboardTypeNumberPad;
    
    value2Text.returnKeyType = UIReturnKeyDone;
    value2Text.clearButtonMode = UITextFieldViewModeNever;
    value2Text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    value2Text.textAlignment = ALIGN_CENTER;
    value2Text.adjustsFontSizeToFitWidth = true;
    value2Text.minimumFontSize = 17.0;
    value2Text.text = @"100";
    value2Text.tag = 1;
    [value2Text setAccessibilityValue:[NSString stringWithFormat:@"100 %@", conf.unit2 ]];

    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [valueLabel addGestureRecognizer:tapRecognizer];

    UITapGestureRecognizer *tap2Recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tap2Recognizer setNumberOfTapsRequired:1];
    [value2Label addGestureRecognizer:tap2Recognizer];
    
    UIImage* pencilImage = [UIImage imageNamed:@"pencil"];
    if (pencilImage!=nil) {
        pencil2ImageView = [[UIImageView alloc] initWithImage:pencilImage];
        pencil2ImageView.frame = CGRectMake(0, 0, pencilImage.size.width, pencilImage.size.height);
        pencil2ImageView.isAccessibilityElement = NO;
    }
    pencilImageView.frame = CGRectMake( valueFrame.size.width-pencilImage.size.width-10 , (valueFrame.size.height-pencilImage.size.height)/2, pencilImage.size.width, pencilImage.size.height);

    pencil2ImageView.frame = CGRectMake( value2Frame.origin.x+value2Frame.size.width-pencilImage.size.width-10 , (value2Frame.size.height-pencilImage.size.height)/2, pencilImage.size.width, pencilImage.size.height);
    
    
    [self addSubview:pencilImageView];
    [self addSubview:pencil2ImageView];
    
    [self addSubview:valueLabel];
    [self addSubview:valueText];

    [self addSubview:value2Label];
    [self addSubview:value2Text];
    
    [self switchWithActiveValue:0];
}


-(void)handleTap:(UITapGestureRecognizer *)recognizer {
    int mytag = (int)recognizer.view.tag;
    [self switchWithActiveValue:mytag];
}

-(void)switchWithActiveValue:(int)activeValue {
    UIView* accElem=nil;
    if (activeValue==0) {
        value2Label.hidden = NO;
        value2Text.hidden = YES;
        valueLabel.hidden = YES;
        valueText.hidden = NO;
        accElem = valueText;
    }
    else {
        valueLabel.hidden = NO;
        valueText.hidden = YES;
        value2Label.hidden = YES;
        value2Text.hidden = NO;
        accElem = value2Text;
    }
    
    if (UIAccessibilityIsVoiceOverRunning() && accElem!=nil) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^{
            UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, accElem);
        });
        
    }
    

    if (delegate!=nil)
        [delegate activeValue:activeValue];
    
}


-(void)editMode:(BOOL)edit withValueIndex:(int)activeValue {
    //[self switchWithActiveValue:0];
    /*
    [super editMode:edit];
    valueLabel.hidden = edit;
    valueText.hidden = !edit;
    value2Label.hidden = edit;
    value2Text.hidden = !edit;
    */
}


-(void)showPencil:(BOOL)show withValueIndex:(int)activeValue {
    if (activeValue==0)
        pencilImageView.hidden = !show;
    if (activeValue==1)
        pencil2ImageView.hidden = !show;
}



@end
