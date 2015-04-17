//
//  SettingsViewController.h
//  FitHeart
//
//  Created by Bitgears on 19/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTDialogView.h"
#import "GAITrackedViewController.h"
#import "ScreenMaskView.h"

@interface SettingsViewController : GAITrackedViewController<FTDialogDelegate, UIActionSheetDelegate> {
    ScreenMaskView* screenMaskView;

}


@property (strong, nonatomic) IBOutlet UIImageView *resetBkgImageView;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;
- (IBAction)resetButtonAction:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *anonymousDataView;

@property (strong, nonatomic) IBOutlet UIImageView *anonymousBkgImageView;

@property (strong, nonatomic) IBOutlet UIButton *syncButton;
- (IBAction)syncButtonAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *anonymousTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *anonymousDescrLabel;
@property (strong, nonatomic) IBOutlet UISwitch *anonymousSwitch;

-(void)enableScreen;
-(void)disableScreen;

@end
