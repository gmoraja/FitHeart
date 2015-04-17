//
//  FTDateTypeSelectView.m
//  FitHeart
//
//  Created by Bitgears on 05/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FTDateTypeSelectView.h"

static NSArray *datetypes = nil;
static float sliderHeight = 90;


@interface FTDateTypeSelectView() {
    
    Class<FTSection> currentSection;
    FTFrequencySlider *slider;
    
    int selectedValue;
}

@end

@implementation FTDateTypeSelectView


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
        
        datetypes = [[NSArray alloc] initWithObjects:
                 @"DAYS",
                 @"WEEKS",
                 @"MONTHS",
                 nil
                 ];
        
        selectedValue = 0;
        [self initFrequencySlider];
        [self setLabel:@"SHOW"];
        [self setText:@"" withColor:[currentSection mainColor:-1]];
        
    }
    return self;
}

-(void)initFrequencySlider {
    CGRect sliderRect = CGRectMake(0, 0, self.frame.size.width, sliderHeight);
    slider = [UCFSUtil createFrequencySliderWithFrame:sliderRect withSection:currentSection withPositions:datetypes];
    slider.delegate = self;
    
    [contentView addSubview:slider];
    
}

- (void)frequencyChanged:(int)frequency {
    
    selectedValue = frequency;
    NSString *title = [datetypes objectAtIndex:frequency];
    [self setText:title withColor:[currentSection mainColor:-1]];
    
    if (self.delegate!=nil)
        [self.delegate valueChanged:selectedValue];
    
}

-(void)updateValue:(int)value {
    selectedValue = value;
    [slider updatePosition:selectedValue];
    NSString *title = [datetypes objectAtIndex:selectedValue];
    [self setText:title withColor:[currentSection mainColor:-1]];
    
}

-(int)getValue {
    return selectedValue;
}


@end
