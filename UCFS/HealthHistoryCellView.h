//
//  HealthHistoryCellView.h
//  FitHeart
//
//  Created by Bitgears on 09/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTLogData.h"
#import "FTSection.h"

@interface HealthHistoryCellView : UIView {
    Class<FTSection> currentSection;
    FTLogData* currentLogData;
    int goalType;
    
    UILabel* dateLabel;
    UILabel* valueLabel;
    UIImageView *bkgImageView;
    UIImageView* barImageView;
    UIImageView* bar2ImageView;
    
    int minValue;
    int maxValue;


}

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withLogData:(FTLogData*)logData withMinValue:(int)minvalue withMaxValue:(int)maxvalue withGoalType:(int)goal;

- (void)updateWithLogData:(FTLogData*)logData withMinValue:(int)minValue withMaxValue:(int)maxValue;


@end
