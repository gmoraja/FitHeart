//
//  FTSimplePleasureSelectView.m
//  FitHeart
//
//  Created by Bitgears on 22/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "FTSimplePleasureSelectView.h"

static float rowHeight = 37;
static float pickerHeight = 0;
static float pickerWidth = 188;
static NSArray *simplepleasures = nil;

@interface FTSimplePleasureSelectView() {
    
    UIFont *pickerFont;
    AFPickerView *pickerView;
    Class<FTSection> currentSection;
    UIImageView *pickerMaskImage;
    UIView *pickerBkgView;
    int selectedValue;
}

@end;

@implementation FTSimplePleasureSelectView

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
    self = [super initWithFrame:frame withContentFrame:contentFrame withOpenDirection:0];
    if (self) {
        // Initialization code
        currentSection = section;
        pickerFont = [UIFont fontWithName:fontName size:fontSize];
        
        selectedValue = 0;
        [self initPickers];
        [self setLabel:@"TYPE"];
        [self setText:@"" withColor:[currentSection mainColor:-1]];
        openRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 248);
        
        
    }
    return self;
}

-(void)initPickers {
    
    simplepleasures = [[NSArray alloc] initWithObjects:
                  @"POSITIVE EVENTS",
                  @"GRATITUDE",
                  @"SILVER LINING",
                  @"PERSONAL STRENGTHS",
                  @"ACTS OF KINDNESS",
                  nil
                  ];
    
    pickerHeight = rowHeight*5;
    
    float offset_y = 0;
    float offset_x = 80;
    // background
    pickerBkgView = [[UIView alloc] initWithFrame:CGRectMake(0.0, offset_y+(pickerHeight-rowHeight)/2, 320, rowHeight)];
    pickerBkgView.backgroundColor = [currentSection mainColor:-1];
    
    //background mask
    UIImage *picker_mask = [UIImage imageNamed:@"picker_mask"];
    pickerMaskImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, offset_y, picker_mask.size.width, picker_mask.size.height)];
    pickerMaskImage.image = picker_mask;
    
    CGRect activityPickerRect = CGRectMake(offset_x, offset_y, pickerWidth, pickerHeight);
    
    pickerView = [UCFSUtil initPickerWithFrame:activityPickerRect withSection:currentSection withDatasource:self withDelegate:self withFont:pickerFont withRowHeight:rowHeight withIndent:15.0 withAligment:0 withTag:100 ];
    [pickerView reloadData];

    [self setText:[simplepleasures objectAtIndex:selectedValue] withColor:[currentSection mainColor:-1]];
    
    [contentView addSubview:pickerBkgView];
    [contentView addSubview:pickerView];
    [contentView addSubview:pickerMaskImage];
}

- (NSInteger)numberOfRowsInPickerView:(AFPickerView *)pickerView
{
    return [simplepleasures count];
}


- (NSString *)pickerView:(AFPickerView *)pickerView titleForRow:(NSInteger)row
{
    return [simplepleasures objectAtIndex:row];
}


- (void)pickerView:(AFPickerView *)pickerView didSelectRow:(NSInteger)row
{
    selectedValue = (int)row;
    [self setText:[simplepleasures objectAtIndex:row] withColor:[currentSection mainColor:-1]];
    if (self.delegate!=nil)
        [self.delegate valueChanged:selectedValue];
}

-(void)updateValue:(int)value {
    selectedValue = value;
    pickerView.selectedRow = selectedValue;
    [pickerView setNeedsDisplay];
    [self setText:[simplepleasures objectAtIndex:value] withColor:[currentSection mainColor:-1]];
}

-(int)getValue {
    return selectedValue;
}



@end
