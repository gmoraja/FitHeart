//
//  FTReminderSelectView.h
//  FitHeart
//
//  Created by Bitgears on 02/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTExpandableView.h"
#import "FTSection.h"
#import "AFPickerView.h"
#import "FTReminderData.h"
#import "FTFrequencySlider.h"


@protocol FTReminderDelegate
- (void)reminderChanged:(FTReminderData *)reminder;
@end

@interface FTReminderSelectView : FTExpandableView<FTFrequencySliderDelegate, AFPickerViewDataSource, AFPickerViewDelegate> {
    FTReminderData *reminderData;

}

@property (strong, nonatomic) FTReminderData *reminderData;


- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withFont:(NSString*)fontName withFontSize:(float)fontSize;
-(void)updateReminder:(FTReminderData*)reminder;


@end
