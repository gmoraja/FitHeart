//
//  FTActivityPickerView.m
//  FitHeart
//
//  Created by Bitgears on 06/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "FTActivitySelectView.h"
#import "AFPickerView.h"
#import "FTSection.h"
#import "UCFSUtil.h"
#import "FitnessSection.h"

static float rowHeight = 37;
static float pickerHeight = 0;
static float activityPickerWidth = 188;
static NSArray *activities = nil;

@interface FTActivitySelectView() {

    UIFont *pickerFont;
    AFPickerView *activityPickerView;
    Class<FTSection> currentSection;
    UIImageView *pickerMaskImage;
    UIView *pickerBkgView;
    int selectedActivity;
}

@end;


@implementation FTActivitySelectView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withFont:(NSString*)fontName withFontSize:(float)fontSize  {
    CGRect contentFrame = CGRectMake(0, frame.size.height, frame.size.width, 248);
    self = [super initWithFrame:frame withContentFrame:contentFrame];
    if (self) {
        // Initialization code
        currentSection = section;
        pickerFont = [UIFont fontWithName:fontName size:fontSize];
        
        int goal = [currentSection getCurrentGoal];
        selectedActivity = 0;
        [self initPickers];
        [self setLabel:@"ACTIVITY"];
        [self setText:@"" withColor:[currentSection mainColor:goal]];
        openRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 248);

        [self setIsAccessibilityElement:YES];

        
    }
    return self;
}

-(void)initPickers {
    
    activities = [FitnessSection getActivities];
    
    pickerHeight = rowHeight*5;
    
    float offset_y = 0;
    int goal = [currentSection getCurrentGoal];
    
    // background
    pickerBkgView = [[UIView alloc] initWithFrame:CGRectMake(0.0, offset_y+(pickerHeight-rowHeight)/2, 320, rowHeight)];
    pickerBkgView.backgroundColor = [currentSection mainColor:goal];

    //background mask
    UIImage *picker_mask = [UIImage imageNamed:@"picker_mask"];
    pickerMaskImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, offset_y, picker_mask.size.width, picker_mask.size.height)];
    pickerMaskImage.image = picker_mask;
    
    CGRect activityPickerRect = CGRectMake(0, offset_y, activityPickerWidth, pickerHeight);
    
    activityPickerView = [UCFSUtil initPickerWithFrame:activityPickerRect withSection:currentSection withDatasource:self withDelegate:self withFont:pickerFont withRowHeight:rowHeight withIndent:15.0 withAligment:2 withTag:100 ];
    [activityPickerView reloadData];

    [self setText:[activities objectAtIndex:selectedActivity]];

    [contentView addSubview:pickerBkgView];
    [contentView addSubview:activityPickerView];
    [contentView addSubview:pickerMaskImage];
}

- (NSInteger)numberOfRowsInPickerView:(AFPickerView *)pickerView
{
    return [activities count];
}


- (NSString *)pickerView:(AFPickerView *)pickerView titleForRow:(NSInteger)row
{
    return [activities objectAtIndex:row];
}


- (void)pickerView:(AFPickerView *)pickerView didSelectRow:(NSInteger)row
{
    selectedActivity = row;
    [self setText:[activities objectAtIndex:row]];
}

-(void)updateActivity:(int)activity {
    selectedActivity = activity;
    activityPickerView.selectedRow = selectedActivity;
    [activityPickerView setNeedsDisplay];
    [self setText:[activities objectAtIndex:activity]];
    
    [self setAccessibilityValue:[activities objectAtIndex:activity]];

}

-(int)getActivity {
    return selectedActivity;
}

@end
