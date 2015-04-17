//
//  FTGoalHistoryCellView.h
//  FitHeart
//
//  Created by Bitgears on 27/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTGoalGroupedData.h"
#import "FTSection.h"

@interface FTGoalHistoryCellView : UIView {
    Class<FTSection> currentSection;
    FTGoalGroupedData* currentGoalGroupedData;
    
    UILabel* dateLabel;
    UILabel* numberLabel;
    UIImageView *goalStatusImageView;
    UIImageView *goalBarImageView;

}

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withData:(FTGoalGroupedData*)goalGroupedData withBarPerc:(int)barPerc;

- (void)updateWithData:(FTGoalGroupedData*)goalGroupedData withBarPerc:(int)barPerc;

@end
