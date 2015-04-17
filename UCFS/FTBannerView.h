//
//  FTBannerView.h
//  FitHeart
//
//  Created by Bitgears on 20/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTSection.h"
#import "FTNotification.h"
#import "RTLabel.h"

@protocol FTBannerDelegate
- (void)notificationReload;
- (void)notificationAction:(FTNotification*)notification;
@end

@interface FTBannerView : UIView {
    Class<FTSection> currentSection;
    UIScrollView* scrollView;
    RTLabel* messageLabel;
    UIButton* reloadButton;
    FTNotification* currentNotification;
}

@property (weak) id <FTBannerDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section;
- (void)updateWithNotification:(FTNotification*)notification;


@end
