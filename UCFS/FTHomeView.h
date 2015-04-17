//
//  FTHomeView.h
//  FitHeart
//
//  Created by Bitgears on 05/02/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTSection.h"
#import "FTGoalData.h"
#import "FTEntriesGraph.h"
#import "FTHomeDatetypeSelectView.h"

@protocol FTHomeViewDelegate
- (void)buttonHistoryTouch;
- (void)buttonGoalTouch;
- (void)buttonInfoTouch;
- (void)buttonListTouch;
- (void)buttonEntryTouchWithDate:(FTGoalData*)goalData;
- (void)buttonDateTypeTouch:(int)dateType;
@end

@interface FTHomeView : UIView<FTEntriesGraphDelegate,FTHomeDatetypeSelectViewDelegate> {
    FTGoalData* currentGoalData;
    int currentDateType;
    int currentSelectedEntry;
}

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section;
- (void)setGoalText:(NSString*)text textColor:(UIColor*)color;
- (void)setUnitText:(NSString*)text textColor:(UIColor*)color;
- (void)updateGoalData:(FTGoalData*)goalData withEntries:(NSMutableArray*)items withDateType:(int)dateType withLastLog:(FTLogData*)lastLogData;

@property (weak) id <FTHomeViewDelegate> delegate;
@property (assign) int currentDateType;


@end
