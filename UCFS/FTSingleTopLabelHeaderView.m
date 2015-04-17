//
//  FTSingleTopLabelHeaderView.m
//  FitHeart
//
//  Created by Bitgears on 30/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "FTSingleTopLabelHeaderView.h"

@implementation FTSingleTopLabelHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withConf:(FTHeaderConf*)headerConf {
    self = [super initWithFrame:frame withConf:headerConf];
    if (self) {
        // Initialization code
        [self initTopLabel];

        CGRect valueTextFrame = CGRectMake(valueText.frame.origin.x, valueText.frame.origin.y+6, valueText.frame.size.width, valueText.frame.size.height);
        valueText.frame = valueTextFrame;
        valueLabel.frame = valueTextFrame;

    }
    return self;
}


- (void)initTopLabel {
    
    float offset_x = (self.frame.size.width-conf.valueTextWidth)/2;
    float offset_y = 8;
    
    CGRect topLabelFrame = CGRectMake(offset_x, offset_y, conf.valueTextWidth, 10);

    topLabel = [[UILabel alloc] initWithFrame:topLabelFrame];
    topLabel.textColor = conf.topTextColor;
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.font = [UIFont fontWithName:@"Futura-Medium" size:(11.0)];
    topLabel.textAlignment =  ALIGN_CENTER;
    topLabel.numberOfLines = 1;
    topLabel.text = conf.topText;
    
    [self addSubview:topLabel];
    
}


@end
