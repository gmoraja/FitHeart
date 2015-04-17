//
//  FTMainSelector.m
//  FitHeart
//
//  Created by Bitgears on 27/11/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//


#import "FTMainSelector.h"
#import "FTSection.h"
#import "FitnessHomeViewController.h"
#import "NutritionHomeViewController.h"
#import "MoodHomeViewController.h"
#import "HealthHomeViewController.h"

CGFloat     const BTN_WIDTH = 80.0;
CGFloat     const BTN_HEIGHT = 78.0;

@interface FTMainSelector() {
    UIImage *fitnessMainSelectorImage;
    UIImage *healthMainSelectorImage;
    UIImage *nutritionMainSelectorImage;
    UIImage *moodMainSelectorImage;
    
    UIImageView *mainSelectorImageView;
    
    UIButton *fitnessButton;
    UIButton *healthButton;
    UIButton *nutritionButton;
    UIButton *moodButton;
    
    SectionType currentType;
}

@end



@implementation FTMainSelector

@synthesize delegate;
@synthesize isEnabled;

- (id)initWithFrame:(CGRect)frame sectionType:(SectionType)type {
    self = [super initWithFrame:frame];
    if (self) {
        isEnabled = FALSE;
        currentType = type;
        
        // Initialization code
        fitnessMainSelectorImage = [UIImage imageNamed:@"fitness_main_selector_selected"];
        healthMainSelectorImage = [UIImage imageNamed:@"health_main_selector_selected"];
        nutritionMainSelectorImage = [UIImage imageNamed:@"nutrition_main_selector_selected"];
        moodMainSelectorImage = [UIImage imageNamed:@"mood_main_selector_selected"];
        
        UIImage *tmpImage = [UIImage imageNamed:@"main_selector_base"];
        mainSelectorImageView = [[UIImageView alloc] initWithImage:tmpImage];
        mainSelectorImageView.frame = CGRectMake(0,0, tmpImage.size.width, tmpImage.size.height);
        [self switchImage:type];
        
        fitnessButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, BTN_WIDTH, BTN_HEIGHT)];
        healthButton = [[UIButton alloc] initWithFrame:CGRectMake(80,0, BTN_WIDTH, BTN_HEIGHT)];
        nutritionButton = [[UIButton alloc] initWithFrame:CGRectMake(160,0, BTN_WIDTH, BTN_HEIGHT)];
        moodButton = [[UIButton alloc] initWithFrame:CGRectMake(240,0, BTN_WIDTH, BTN_HEIGHT)];
        
        fitnessButton.backgroundColor = [UIColor clearColor];
        healthButton.backgroundColor = [UIColor clearColor];
        nutritionButton.backgroundColor = [UIColor clearColor];
        moodButton.backgroundColor = [UIColor clearColor];
        
        fitnessButton.tag = SECTION_FITNESS;
        healthButton.tag = SECTION_HEALTH;
        moodButton.tag = SECTION_MOOD;
        
        [fitnessButton addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [healthButton addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [nutritionButton addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [moodButton addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [fitnessButton addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [healthButton addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [nutritionButton addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [moodButton addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];

        
        
        [self addSubview:mainSelectorImageView];
        [self addSubview:fitnessButton];
        [self addSubview:healthButton];
        [self addSubview:nutritionButton];
        [self addSubview:moodButton];
    }
    return self;
}

-(void)switchImage:(SectionType)type {
    UIImage *startImage = nil;
    switch(type) {
        case SECTION_FITNESS: startImage = fitnessMainSelectorImage; break;
        case SECTION_HEALTH: startImage = healthMainSelectorImage; break;
        case SECTION_MOOD: startImage = moodMainSelectorImage; break;
    }
    mainSelectorImageView.image = startImage;
}

- (IBAction)touchDown:(UIButton*)sender {
    if (isEnabled)
        [self switchImage:[sender tag]];

}

- (IBAction)touchUpInside:(UIButton*)sender {
    if (isEnabled)
        [self navigateToSection:[sender tag]];
    
}

- (void)navigateToSection:(SectionType)type {
    if (type!=currentType) {
        [self.delegate changeSection:type ];

    }

}



@end
