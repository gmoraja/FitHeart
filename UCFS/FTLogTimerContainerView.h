//
//  FTLogTimerContainerView.h
//  FitHeart
//
//  Created by Bitgears on 17/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTLogContainerView.h"

@interface FTLogTimerContainerView : FTLogContainerView<UIAlertViewDelegate> {
    
}

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withGoalData:(FTGoalData*)goalData withLogData:(FTLogData*)logData;

@end
