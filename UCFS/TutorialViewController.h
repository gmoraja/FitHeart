//
//  TutorialViewController.h
//  FitHeart
//
//  Created by Bitgears on 24/09/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface TutorialViewController : GAITrackedViewController<UIScrollViewDelegate> {
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withFirstLaunch:(BOOL)firstLaunch;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *getStartedButton;
- (IBAction)getStartedAction:(id)sender;

@end
