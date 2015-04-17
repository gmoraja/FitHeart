//
//  FTEffortSelectView.m
//  FitHeart
//
//  Created by Bitgears on 09/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "FTEffortSelectView.h"

static NSArray *efforts = nil;
static NSArray *effortDescr = nil;
static float sliderHeight = 90;
static float descrWidth = 180;
static float descrHeight = 50;

@interface FTEffortSelectView() {
    
    Class<FTSection> currentSection;
    FTFrequencySlider *slider;
    UILabel *descrLabel;
    
    int selectedEffort;
}

@end

@implementation FTEffortSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withFont:(NSString*)fontName withFontSize:(float)fontSize  {
    CGRect contentFrame = CGRectMake(0, frame.size.height, frame.size.width, 160);
    self = [super initWithFrame:frame withContentFrame:contentFrame];
    if (self) {
        // Initialization code
        currentSection = section;
        
        efforts = [[NSArray alloc] initWithObjects:
                   @"Very Easy",
                   @"Easy",
                   @"Somewhat Easy",
                   @"Somewhat Hard",
                   @"Hard",
                   @"Very Hard",
                   nil
                   ];

        effortDescr = [[NSArray alloc] initWithObjects:
                   @"sedentary, like riding in a car",
                   @"breathing not noticeable, can hold a conversation",
                   @"breathing noticeable, can hold a conversation",
                   @"labored breathing, can hold short conversation",
                   @"can only speak a few words",
                   @"can't talk",
                   nil
                   ];
        
        int goal = [currentSection getCurrentGoal];
        selectedEffort = 0;
        [self initFrequencySlider];
        [self initDescriptionLabel];
        [self setLabel:@"EFFORT"];
        [self setText:@"" withColor:[currentSection mainColor:goal]];
        [self setAccessibilityHint:@"Tap to open the effort selector screen"];
        
    }
    return self;
}

-(void)initFrequencySlider {
    CGRect sliderRect = CGRectMake(0, 0, self.frame.size.width, sliderHeight);
    slider = [UCFSUtil createFrequencySliderWithFrame:sliderRect withSection:currentSection withPositions:efforts];
    slider.delegate = self;
    
    [contentView addSubview:slider];
    
}

-(void)initDescriptionLabel {
    descrLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-descrWidth)/2, sliderHeight+10, descrWidth, descrHeight)];
    descrLabel.textColor = [UIColor lightGrayColor];
    descrLabel.backgroundColor = [UIColor clearColor];
    descrLabel.font = [UIFont fontWithName:@"S" size:(18.0)];
    descrLabel.text = @"";
    descrLabel.textAlignment =  ALIGN_CENTER;
    descrLabel.lineBreakMode = UILineBreakModeWordWrap;
    descrLabel.numberOfLines = 0;
    [contentView addSubview:descrLabel];
    
}


- (void)frequencyChanged:(int)frequency {

    selectedEffort = frequency;
    NSString *title = [efforts objectAtIndex:frequency];
    [self setText:title];
    
    descrLabel.text = [effortDescr objectAtIndex:frequency];
}

-(void)updateEffort:(int)effort {
    selectedEffort = effort;
    [slider updatePosition:selectedEffort];
    NSString *title = [efforts objectAtIndex:selectedEffort];
    [self setText:title];
    descrLabel.text = [effortDescr objectAtIndex:selectedEffort];
    
    [self setAccessibilityValue:[effortDescr objectAtIndex:selectedEffort]];


}

-(int)getEffort {
    return selectedEffort;
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
