//
//  FitnessSwitcherView.h
//  FitHeart
//
//  Created by Bitgears on 25/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat     const BTN_WIDTH;
extern CGFloat     const BTN_HEIGHT;

@protocol FitnessSwitcherDelegate
- (void)fitnessChangeDataType:(int)type;
@end

@interface FitnessSwitcherView : UIView {
    BOOL isEnabled;
}

@property (assign) id <FitnessSwitcherDelegate> delegate;
@property (assign) BOOL isEnabled;

- (id)initWithFrame:(CGRect)frame dataType:(int)type;
-(void)switchImage:(int)type;

@end
