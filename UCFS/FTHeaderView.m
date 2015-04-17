//
//  FTHeaderView.m
//  FitHeart
//
//  Created by Bitgears on 12/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//


#import "FTHeaderView.h"


@implementation FTHeaderView

@synthesize valueText;
@synthesize valueLabel;
@synthesize valueUnit;
@synthesize conf;
@synthesize editModeEnabled;
@synthesize arrowType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        valueTextHeight = 40;
        labelTextHeight = 21;
        labelPadding = 10;
        editModeEnabled = FALSE;
        arrowType = 0;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withConf:(FTHeaderConf*)headerConf {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        valueTextHeight = 40;
        labelTextHeight = 21;
        labelPadding = 10;
        conf = headerConf;
        self.backgroundColor = [UIColor clearColor];

        [self initArrow];

    }
    return self;
}

-(void)initArrow {
    UIImage *arrowImage = nil;
    if (arrowType==1)
        arrowImage = [UIImage imageNamed:@"header_arrowup_bkg"];
    else
        if (arrowType==2)
            arrowImage = [UIImage imageNamed:@"header_arrowdown_bkg"];

    if (arrowImage!=nil) {
        UIImageView* arrowImageView = [[UIImageView alloc] initWithImage:arrowImage];
        arrowImageView.frame = CGRectMake(0, 0, 320, arrowImage.size.height);
        [self addSubview:arrowImageView];
        
    }
    
    UIImage* pencilImage = [UIImage imageNamed:@"pencil"];
    if (pencilImage!=nil) {
        pencilImageView = [[UIImageView alloc] initWithImage:pencilImage];
        pencilImageView.frame = CGRectMake(0, 0, pencilImage.size.width, pencilImage.size.height);
        pencilImageView.isAccessibilityElement = NO;
        
    }

}


- (void)editText {
    [valueText becomeFirstResponder];
}

- (void)editMode:(BOOL)edit  withValueIndex:(int)activeValue {
    editModeEnabled = edit;
}

- (void)updateConf:(FTHeaderConf*)headerConf {
    conf = headerConf;
}

-(void)showPencil:(BOOL)show withValueIndex:(int)activeValue {
    
}


@end
