//
//  FTLogListContainerView.h
//  FitHeart
//
//  Created by Bitgears on 10/02/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCFSUtil.h"
#import "FTSection.h"
#import "FTGoalData.h"

@protocol FTLogListContainerDelegate
- (void)buttonEntryTouchWithDate:(FTLogData*)logData;
@end

@interface FTLogListContainerView : UIView<UITableViewDelegate, UITableViewDataSource> {
    NSArray *items;
    
}


@property (weak) id <FTLogListContainerDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withGoalType:(int)goal;
-(void)updateData;

@end
