//
//  FTHomeDatetypeSelectView.h
//  FitHeart
//
//  Created by Bitgears on 07/02/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FTHomeDatetypeSelectViewDelegate
- (void)bottomButtonTouchUpInside:(int)dateType;
@end

@interface FTHomeDatetypeSelectView : UIView {
    UIColor* selectedTextColor;
    UIColor* textColor;
    UIButton* dayLabel;
    UIButton* monthLabel;
    UIButton* weekLabel;
    
}


@property (weak) id <FTHomeDatetypeSelectViewDelegate> delegate;
@property (assign) int currentDateType;
@property (strong)  UIColor* selectedTextColor;
@property (strong)  UIColor* textColor;

-(void)updateUIWithDatetype:(int)datetype withAnimation:(BOOL)animated;


@end
