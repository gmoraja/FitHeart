//
//  MoodHomeViewController.h
//  FitHeart
//
//  Created by Bitgears on 19/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTSectionHomeViewController.h"



@interface MoodHomeViewController : FTSectionHomeViewController {


}


@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIButton *enterMoodButton;

- (id)initWithAction:(FTNotificationAction*)action;
+ (NSString*)getMoodMessage;
- (IBAction)enterMoodAction:(id)sender;


@end
