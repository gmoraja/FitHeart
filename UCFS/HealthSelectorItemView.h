//
//  HealthSelectorItemView.h
//  FitHeart
//
//  Created by Bitgears on 09/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HealthSection.h"
#import "FTLogData.h"

@interface HealthSelectorItemView : UIView {
    int dataType;
    FTLogData* currentLogData;
}

- (id)initWithFrame:(CGRect)frame withDataType:(int)goalType;
- (void)updateWithLog:(FTLogData*)logData;

@end
