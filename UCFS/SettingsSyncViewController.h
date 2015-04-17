//
//  SettingsSyncViewController.h
//  FitHeart
//
//  Created by Bitgears on 15/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface SettingsSyncViewController : GAITrackedViewController {
    
}


@property (strong, nonatomic) IBOutlet UIView *syncView;
@property (strong, nonatomic) IBOutlet UIView *successView;
@property (strong, nonatomic) IBOutlet UIView *errorView;
@property (strong, nonatomic) IBOutlet UILabel *syncSuccessLabel;
@property (strong, nonatomic) IBOutlet UILabel *syncFailedLabel;
@property (strong, nonatomic) IBOutlet UIButton *syncNoButton;
@property (strong, nonatomic) IBOutlet UIButton *syncYesButton;
- (IBAction)syncNoAction:(id)sender;
- (IBAction)syncYesAction:(id)sender;

@end
