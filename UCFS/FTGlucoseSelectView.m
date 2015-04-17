//
//  FTGlucoseSelectView.m
//  FitHeart
//
//  Created by Bitgears on 25/02/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FTGlucoseSelectView.h"
#import "HealthSection.h"

static NSArray *values = nil;
static float sliderHeight = 90;

@interface FTGlucoseSelectView() {
    
    Class<FTSection> currentSection;
    FTFrequencySlider *slider;
    
    int selectedValue;
}

@end

@implementation FTGlucoseSelectView

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
        
        values = [HealthSection getGlucoseTimes];
        
        selectedValue = 0;
        [self initFrequencySlider];
        [self setLabel:@"TIME"];
        [self setText:@"" withColor:[currentSection mainColor:-1]];
        
    }
    return self;
}

-(void)initFrequencySlider {
    CGRect sliderRect = CGRectMake(0, 0, self.frame.size.width, sliderHeight);
    slider = [UCFSUtil createFrequencySliderWithFrame:sliderRect withSection:currentSection withPositions:values];
    slider.delegate = self;
    
    [contentView addSubview:slider];
    
}

- (void)frequencyChanged:(int)frequency {
    
    selectedValue = frequency;
    NSString *title = [values objectAtIndex:frequency];
    [self setText:title withColor:[currentSection mainColor:-1]];
}

-(void)updateValue:(int)value {
    selectedValue = value;
    [slider updatePosition:selectedValue];
    NSString *title = [values objectAtIndex:selectedValue];
    [self setText:title withColor:[currentSection mainColor:-1]];
    [self setAccessibilityValue:title];
    
}

-(int)getValue {
    return selectedValue;
}


@end
