//
//  FTWeeksLogCellView.h
//  FitHeart
//
//  Created by Bitgears on 01/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTLogData.h"
#import "FTGoalData.h"
#import "FTSection.h"


@protocol FTWeeksLogCellProtocol
- (void)deleteLog:(FTLogData*)logData withView:(UIView*)view;
- (void)editLog:(FTLogData*)logData withView:(UIView*)view;
@end


@interface FTWeeksLogCellView : UIView {
    Class<FTSection> currentSection;
    UILabel* activityLabel;
    UILabel* valueLabel;
    FTGoalData* goal;
    FTLogData* log;
    
}


@property (weak) id <FTWeeksLogCellProtocol> delegate;

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withGoalData:(FTGoalData*)goalData withLogData:(FTLogData*)logData
;
- (void)updateWithGoalData:(FTGoalData*)goalData withLogData:(FTLogData*)logData;
- (void)closeDelete;
- (void)openDelete;

@end
