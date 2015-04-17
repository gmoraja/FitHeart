//
//  HomeActionDialogView.h
//  FitHeart
//
//  Created by Bitgears on 25/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTSection.h"

@protocol FTHomeActionDialogViewDelegate
- (void)buttonChangeGoalTouch;
- (void)buttonReminderTouch;
- (void)buttonNewGoalTouch;
- (void)closeTouch;
@end


@interface FTHomeActionDialogView : UIView {
    
}


@property (weak) id <FTHomeActionDialogViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section;


@end
