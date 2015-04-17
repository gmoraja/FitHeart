//
//  FTMealSelectView.m
//  FitHeart
//
//  Created by Bitgears on 30/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "FTMealSelectView.h"


static NSArray *meals = nil;
static float sliderHeight = 90;

@interface FTMealSelectView() {
    
    Class<FTSection> currentSection;
    FTFrequencySlider *slider;
    
    int selectedValue;
}

@end

@implementation FTMealSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withFont:(NSString*)fontName withFontSize:(float)fontSize  {
    CGRect contentFrame = CGRectMake(0, frame.size.height, frame.size.width, 100);
    self = [super initWithFrame:frame withContentFrame:contentFrame];
    if (self) {
        // Initialization code
        currentSection = section;
        
        //meals = [NutritionSection getMeals];
        
        selectedValue = 0;
        [self initFrequencySlider];
        [self setLabel:@"MEAL"];
        [self setText:@"" withColor:[currentSection mainColor:-1]];
        
    }
    return self;
}

-(void)initFrequencySlider {
    CGRect sliderRect = CGRectMake(0, 0, self.frame.size.width, sliderHeight);
    slider = [UCFSUtil createFrequencySliderWithFrame:sliderRect withSection:currentSection withPositions:meals];
    slider.delegate = self;
    
    [contentView addSubview:slider];
    
}

- (void)frequencyChanged:(int)frequency {
    
    selectedValue = frequency;
    NSString *title = [meals objectAtIndex:frequency];
    [self setText:title withColor:[currentSection mainColor:-1]];
}

-(void)updateValue:(int)value {
    selectedValue = value;
    [slider updatePosition:selectedValue];
    NSString *title = [meals objectAtIndex:selectedValue];
    [self setText:title withColor:[currentSection mainColor:-1]];
    
}

-(int)getValue {
    return selectedValue;
}




@end
