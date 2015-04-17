//
//  FTEmptyHeaderView.m
//  FitHeart
//
//  Created by Bitgears on 10/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FTEmptyHeaderView.h"

@implementation FTEmptyHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withConf:(FTHeaderConf*)headerConf {
    arrowType = 0;
    self = [super initWithFrame:frame withConf:headerConf];
    if (self) {
        // Initialization code
        if (valueText!=nil) valueText.hidden = YES;
        if (valueLabel!=nil) valueLabel.hidden = YES;
        

    }
    return self;
}




@end
