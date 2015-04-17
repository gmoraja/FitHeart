//
//  FitnessSwitcherView.m
//  FitHeart
//
//  Created by Bitgears on 25/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FitnessSwitcherView.h"
#import "FitnessSection.h"

CGFloat     const BTN_WIDTH = 160.0;
CGFloat     const BTN_HEIGHT = 80.0;

@interface FitnessSwitcherView() {
    UIImage* minutesOnImage;
    UIImage* minutesOffImage;
    UIImage* stepOnImage;
    UIImage* stepOffImage;

    UIButton *minutesButton;
    UIButton *stepButton;
    
    int currentType;
}

@end

@implementation FitnessSwitcherView

@synthesize isEnabled;
@synthesize delegate;


- (id)initWithFrame:(CGRect)frame dataType:(int)type {
    self = [super initWithFrame:frame];
    if (self) {
        isEnabled = TRUE;
        currentType = type;
        
        // Initialization code
        minutesOnImage = [UIImage imageNamed:@"fitness_minutes_on"];
        minutesOffImage = [UIImage imageNamed:@"fitness_minutes_off"];
        stepOnImage = [UIImage imageNamed:@"fitness_step_on"];
        stepOffImage = [UIImage imageNamed:@"fitness_step_off"];
        
        minutesButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, BTN_WIDTH, BTN_HEIGHT)];
        minutesButton.tag = FITNESS_GOAL_TIME;
        //[minutesButton addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [minutesButton addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [minutesButton setAccessibilityLabel:@"Minutes"];
        [minutesButton setAccessibilityHint:@"Tap to switch in minutes unit"];
        [minutesButton setAccessibilityValue:@"Minutes selected"];

        stepButton = [[UIButton alloc] initWithFrame:CGRectMake(BTN_WIDTH,0, BTN_WIDTH, BTN_HEIGHT)];
        stepButton.tag = FITNESS_GOAL_STEPS;
        //[stepButton addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [stepButton addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [stepButton setAccessibilityLabel:@"Steps"];
        [stepButton setAccessibilityHint:@"Tap to switch in steps unit"];
        [stepButton setAccessibilityValue:@"Steps not selected"];

        [self switchImage:type];
        
        [self addSubview:minutesButton];
        [self addSubview:stepButton];
        
    }
    return self;
}


- (IBAction)touchUpInside:(UIButton*)sender {
    if (isEnabled) {
        int dataType = (int)[sender tag];
        if (delegate)
            [delegate fitnessChangeDataType:dataType];
        [self switchImage:dataType];
    }
}

-(void)switchImage:(int)type {
    switch(type) {
        case FITNESS_GOAL_TIME:
            [minutesButton setBackgroundImage:minutesOnImage forState:UIControlStateNormal];
            [stepButton setBackgroundImage:stepOffImage forState:UIControlStateNormal];
            [minutesButton setAccessibilityValue:@"Minutes selected"];
            [stepButton setAccessibilityValue:@"Steps not selected"];
            break;
        case FITNESS_GOAL_STEPS:
            [minutesButton setBackgroundImage:minutesOffImage forState:UIControlStateNormal];
            [stepButton setBackgroundImage:stepOnImage forState:UIControlStateNormal];
            [minutesButton setAccessibilityValue:@"Minutes not selected"];
            [stepButton setAccessibilityValue:@"Steps selected"];
            break;
    }
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
