//
//  HomeActionDialogView.m
//  FitHeart
//
//  Created by Bitgears on 25/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FTHomeActionDialogView.h"
#import "FTSection.h"
#import "UCFSUtil.h"

@interface FTHomeActionDialogView() {
    Class<FTSection> currentSection;
    
    UIButton *changeGoalButton;
    UIButton *changeReminderButton;
    UIButton *newGoalButton;

}

@end

@implementation FTHomeActionDialogView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section {
    self = [super initWithFrame:frame];
    if (self) {
        currentSection = section;

        float offset_y = 20;
        if ([UCFSUtil deviceSystemIOS7])
            offset_y= 0;
        
        UIImage* bkgImage = [UIImage imageNamed:@"home_action_bkg"];
        UIImageView* bkgImageView = [[UIImageView alloc] initWithImage:bkgImage];
        bkgImageView.frame = CGRectMake(0, offset_y, 320, 213);
        
        UIImage* buttonImage = [UIImage imageNamed:@"home_action_button"];

        
        changeGoalButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 10+offset_y, buttonImage.size.width, buttonImage.size.height)];
        [changeGoalButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [changeGoalButton addTarget:self action:@selector(changeGoalButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [changeGoalButton setTitle:@"Change Goal" forState:UIControlStateNormal];
        [changeGoalButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [changeGoalButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        changeGoalButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16.0];
        changeGoalButton.userInteractionEnabled = YES;
        [changeGoalButton setAccessibilityLabel:@"Change Goal" ];
        [changeGoalButton setAccessibilityHint:@"Tap to change current goal value" ];

        changeReminderButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 80+offset_y, buttonImage.size.width, buttonImage.size.height)];
        [changeReminderButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [changeReminderButton addTarget:self action:@selector(changeReminderButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [changeReminderButton setTitle:@"Change Reminder" forState:UIControlStateNormal];
        [changeReminderButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [changeReminderButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        changeReminderButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16.0];
        changeReminderButton.userInteractionEnabled = YES;
        [changeReminderButton setAccessibilityLabel:@"Change Reminder" ];
        [changeReminderButton setAccessibilityHint:@"Tap to change current reminder settings" ];
        
        newGoalButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 150+offset_y, buttonImage.size.width, buttonImage.size.height)];
        [newGoalButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [newGoalButton addTarget:self action:@selector(newGoalButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [newGoalButton setTitle:@"Set a New Goal" forState:UIControlStateNormal];
        [newGoalButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [newGoalButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        newGoalButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16.0];
        newGoalButton.userInteractionEnabled = YES;
        [newGoalButton setAccessibilityLabel:@"Set a New Goal" ];
        [newGoalButton setAccessibilityHint:@"Tap to set a new goal" ];
       
        
        UIImage* triangleImage = [UIImage imageNamed:@"triangle_blue"];
        UIImageView* triangleImageView = [[UIImageView alloc] initWithImage:triangleImage];
        triangleImageView.frame = CGRectMake(278, 0, triangleImage.size.width, triangleImage.size.height);

        
        [self addSubview:bkgImageView];
        [self addSubview:changeGoalButton];
        [self addSubview:changeReminderButton];
        [self addSubview:newGoalButton];
        [self addSubview:triangleImageView];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
        [self addGestureRecognizer:tapRecognizer];

        
    }
    
    return self;
}

- (IBAction)changeGoalButtonAction:(UIButton*)sender {
    if (self.delegate!=nil)
        [self.delegate buttonChangeGoalTouch];
}

- (IBAction)changeReminderButtonAction:(UIButton*)sender {
    if (self.delegate!=nil)
        [self.delegate buttonReminderTouch];
}

- (IBAction)newGoalButtonAction:(UIButton*)sender {
    if (self.delegate!=nil)
        [self.delegate buttonNewGoalTouch];
}

- (void)didTap:(id)sender
{
    if (self.delegate!=nil)
        [self.delegate closeTouch];
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
