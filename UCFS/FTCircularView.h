//
//  FTCircularView.h
//  FitHeart
//
//  Created by Bitgears on 27/11/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTSection.h"
#import "FTGoalData.h"
#import "UITextArc.h"
#import "FTEntriesGraph.h"

@protocol FTCircularViewDelegate
    - (void)buttonGoalTouch;
    - (void)buttonInfoTouch;
    - (void)buttonListTouch;
    - (void)buttonEntryTouchWithDate:(NSString*)dateValue;
    - (void)buttonDateTypeTouch:(int)dateType;
@end

@interface FTCircularView : UIView<FTEntriesGraphDelegate> {
    FTGoalData* currentGoalData;
    int currentDateType;
    int currentSelectedEntry;

}

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section;
- (void)setGoalText:(NSString*)text textColor:(UIColor*)color;
- (void)setUnitText:(NSString*)text textColor:(UIColor*)color;
- (void)updateGoalData:(FTGoalData*)goalData withEntries:(NSMutableArray*)items withDateType:(int)dateType withLastLog:(FTLogData*)lastLogData;

@property (weak) id <FTCircularViewDelegate> delegate;
@property (assign) int currentDateType;


@end
