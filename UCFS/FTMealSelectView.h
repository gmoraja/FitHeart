//
//  FTMealSelectView.h
//  FitHeart
//
//  Created by Bitgears on 30/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTExpandableView.h"
#import "FTSection.h"
#import "UCFSUtil.h"
#import "FTFrequencySlider.h"

@interface FTMealSelectView : FTExpandableView<FTFrequencySliderDelegate> {
    
}

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withFont:(NSString*)fontName withFontSize:(float)fontSize;
-(void)updateValue:(int)value;
-(int)getValue;



@end
