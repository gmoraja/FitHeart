//
//  FTMainSelector.h
//  FitHeart
//
//  Created by Bitgears on 27/11/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTSection.h"


extern CGFloat     const BTN_WIDTH;
extern CGFloat     const BTN_HEIGHT;

@protocol FTMainSelectorDelegate
    - (void)changeSection:(SectionType) type;
@end

@interface FTMainSelector : UIView {
    BOOL isEnabled;
}

- (id)initWithFrame:(CGRect)frame sectionType:(SectionType)type;

@property (assign) id <FTMainSelectorDelegate> delegate;
@property (assign) BOOL isEnabled;

-(void)switchImage:(SectionType)type;

@end
