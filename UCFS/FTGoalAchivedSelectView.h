//
//  FTGoalAchivedSelectView.h
//  FitHeart
//
//  Created by Bitgears on 10/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTExpandableView.h"
#import "FTSection.h"
#import "AFPickerView.h"
#import "FTFrequencySlider.h"

@protocol FTGoalAchivedDelegate
- (void)valueChanged:(int)achivedType withDate:(NSDate*)achivedDate;
@end

@interface FTGoalAchivedSelectView : FTExpandableView<FTFrequencySliderDelegate, AFPickerViewDataSource, AFPickerViewDelegate> {
    int currentAchivedType;
    NSDate* currentAchivedDate;
    
}

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withFont:(NSString*)fontName withFontSize:(float)fontSize;
- (void)updateAchivedType:(int)achivedType withDate:(NSDate*)achivedDate;
- (NSDate*)getAchivedDate;
- (int)getAchivedType;

@end
