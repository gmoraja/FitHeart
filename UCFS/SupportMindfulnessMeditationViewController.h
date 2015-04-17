//
//  SupportMindfulnessMeditationViewController.h
//  FitHeart
//
//  Created by Bitgears on 23/02/15.
//  Copyright (c) 2015 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface SupportMindfulnessMeditationViewController : GAITrackedViewController<UIScrollViewDelegate> {
    
}

@property (strong, nonatomic) IBOutlet UILabel *mainLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;

@end
