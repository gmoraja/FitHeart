//
//  MoodHistoryCellView.h
//  FitHeart
//
//  Created by Bitgears on 06/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTSection.h"
#import "FTDateLogData.h"

@interface MoodHistoryCellView : UIView {
    Class<FTSection> currentSection;
    FTLogData* currentLogData;
    
    UILabel* dateLabel;
    UIImageView *bkgImageView;
    UIImageView *moodImageView;
}


- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withLogData:(FTLogData*)logData;

- (void)updateWithLogData:(FTLogData*)logData;

@end
