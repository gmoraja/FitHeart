//
//  FTEffortSelectView.h
//  FitHeart
//
//  Created by Bitgears on 09/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTExpandableView.h"
#import "FTSection.h"
#import "UCFSUtil.h"
#import "FTFrequencySlider.h"

@interface FTEffortSelectView : FTExpandableView<FTFrequencySliderDelegate> {
    
}

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withFont:(NSString*)fontName withFontSize:(float)fontSize;
-(void)updateEffort:(int)effort;
-(int)getEffort;


@end
