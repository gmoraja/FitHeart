//
//  FTDateTypeSelectView.h
//  FitHeart
//
//  Created by Bitgears on 05/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTExpandableView.h"
#import "FTSection.h"
#import "UCFSUtil.h"
#import "FTFrequencySlider.h"

@interface FTDateTypeSelectView : FTExpandableView<FTFrequencySliderDelegate> {
    
}


- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withFont:(NSString*)fontName withFontSize:(float)fontSize;
-(void)updateValue:(int)value;
-(int)getValue;


@end
