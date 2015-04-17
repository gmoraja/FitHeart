//
//  FTHomeDatetypeSelectView.m
//  FitHeart
//
//  Created by Bitgears on 07/02/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#ifdef __IPHONE_6_0
# define ALIGN_CENTER NSTextAlignmentCenter
#else
# define ALIGN_CENTER UITextAlignmentCenter
#endif

#import "FTHomeDatetypeSelectView.h"

static float TEXT_WIDTH = 40;
static float TEXT_HEIGHT = 40;

@interface FTHomeDatetypeSelectView() {
    CGRect dayFrame;
    CGRect weekFrame;
    CGRect monthFrame;
}

@end

@implementation FTHomeDatetypeSelectView

@synthesize delegate;
@synthesize currentDateType;
@synthesize selectedTextColor;
@synthesize textColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       currentDateType = -1;
        
        monthFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        weekFrame = CGRectMake(frame.origin.x-TEXT_WIDTH, frame.origin.y, frame.size.width, frame.size.height);
        dayFrame = CGRectMake(frame.origin.x-(TEXT_WIDTH*2), frame.origin.y, frame.size.width, frame.size.height);
        
       
        UIImage* datetypeBkg = [UIImage imageNamed:@"btn_datetype_bkg"];
        
        dayLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        dayLabel.frame = CGRectMake(frame.size.width-TEXT_WIDTH, 0, TEXT_WIDTH, TEXT_HEIGHT);
        dayLabel.titleLabel.textColor = [UIColor grayColor];
        dayLabel.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:(17.0)];
        [dayLabel setBackgroundImage:datetypeBkg forState:UIControlStateNormal];
        [dayLabel setBackgroundImage:datetypeBkg forState:UIControlStateHighlighted];
        [dayLabel setTitle:@"DAY" forState:UIControlStateNormal];
        //dayLabel.userInteractionEnabled = TRUE;
        
        weekLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        weekLabel.frame = CGRectMake((frame.size.width-TEXT_WIDTH)/2+3, 0, TEXT_WIDTH, TEXT_HEIGHT);
        weekLabel.titleLabel.textColor = [UIColor grayColor];
        weekLabel.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:(17.0)];
        [weekLabel setBackgroundImage:datetypeBkg forState:UIControlStateNormal];
        [weekLabel setBackgroundImage:datetypeBkg forState:UIControlStateHighlighted];
        [weekLabel setTitle:@"WEEK" forState:UIControlStateNormal];
        //weekLabel.userInteractionEnabled = TRUE;
        
        monthLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        monthLabel.frame = CGRectMake(0, 0, TEXT_WIDTH, TEXT_HEIGHT);
        monthLabel.titleLabel.textColor = [UIColor grayColor];
        monthLabel.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:(17.0)];
        [monthLabel setTitle:@"MONTH" forState:UIControlStateNormal];
        [monthLabel setBackgroundImage:datetypeBkg forState:UIControlStateNormal];
        [monthLabel setBackgroundImage:datetypeBkg forState:UIControlStateHighlighted];
        //monthLabel.userInteractionEnabled = TRUE;
        
        [dayLabel addTarget:self action:@selector(handleDayTap:) forControlEvents:UIControlEventTouchUpInside];
        [weekLabel addTarget:self action:@selector(handleWeekTap:) forControlEvents:UIControlEventTouchUpInside];
        [monthLabel addTarget:self action:@selector(handleMonthTap:) forControlEvents:UIControlEventTouchUpInside];

/*
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [tapRecognizer setNumberOfTapsRequired:1];
        [self addGestureRecognizer:tapRecognizer];
*/
        [self addSubview:dayLabel];
        [self addSubview:weekLabel];
        [self addSubview:monthLabel];
        
        
    }
    return self;
}

-(void)updateUIWithDatetype:(int)datetype withAnimation:(BOOL)animated {
    [dayLabel setTitleColor:textColor forState:UIControlStateNormal];
    [weekLabel setTitleColor:textColor forState:UIControlStateNormal];
    [monthLabel setTitleColor:textColor forState:UIControlStateNormal];
    [dayLabel setTitleColor:selectedTextColor forState:UIControlStateHighlighted];
    [weekLabel setTitleColor:selectedTextColor forState:UIControlStateHighlighted];
    [monthLabel setTitleColor:selectedTextColor forState:UIControlStateHighlighted];

    CGRect destRect;
    switch (datetype) {
        case 0: [dayLabel setTitleColor:selectedTextColor forState:UIControlStateNormal];
                destRect = dayFrame;
                break;
        case 1: [weekLabel setTitleColor:selectedTextColor forState:UIControlStateNormal];
                destRect = weekFrame;
                break;
        case 2: [monthLabel setTitleColor:selectedTextColor forState:UIControlStateNormal];
                destRect = monthFrame;
                break;
    }
    
    if (animated) {
        [UIView animateWithDuration:0.2f animations:^{
            self.frame = destRect;
        }completion:^(BOOL finished) {
        }];
    }
    else {
        self.frame = destRect;
    }
    

    
}

-(void)updateWithDatetype:(int)datetype {
    if (currentDateType!=datetype) {
        currentDateType = datetype;
        
        if (delegate!=nil)
            [self.delegate bottomButtonTouchUpInside:datetype];
        
        [self updateUIWithDatetype:datetype withAnimation:YES];
    }
    
}

-(void)handleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:self];
    if ( CGRectContainsPoint(dayLabel.frame, location) )
        [self updateWithDatetype:0];
    else
        if ( CGRectContainsPoint(weekLabel.frame, location) )
            [self updateWithDatetype:1];
        else
            if ( CGRectContainsPoint(monthLabel.frame, location) )
                [self updateWithDatetype:2];


}


-(void)handleDayTap:(UITapGestureRecognizer *)recognizer {
    [self updateWithDatetype:0];
}

-(void)handleWeekTap:(UITapGestureRecognizer *)recognizer {
    [self updateWithDatetype:1];
}

-(void)handleMonthTap:(UITapGestureRecognizer *)recognizer {
    [self updateWithDatetype:2];
}



@end
