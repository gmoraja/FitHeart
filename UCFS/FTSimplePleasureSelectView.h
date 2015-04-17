//
//  FTSimplePleasureSelectView.h
//  FitHeart
//
//  Created by Bitgears on 22/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTExpandableView.h"
#import "AFPickerView.h"
#import "FTSection.h"
#import "UCFSUtil.h"




@interface FTSimplePleasureSelectView : FTExpandableView<AFPickerViewDataSource, AFPickerViewDelegate> {
    
}

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withFont:(NSString*)fontName withFontSize:(float)fontSize;
-(void)updateValue:(int)value;
-(int)getValue;

@end
