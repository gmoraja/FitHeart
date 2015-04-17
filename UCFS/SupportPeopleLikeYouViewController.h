//
//  SupportPeopleLikeYouViewController.h
//  FitHeart
//
//  Created by Bitgears on 15/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"


@interface SupportPeopleLikeYouViewController : GAITrackedViewController {
    
}

@property (strong, nonatomic) IBOutlet UILabel *mainLabel;
@property (strong, nonatomic) IBOutlet UIButton *bottomButton;
- (IBAction)bottomAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;

@end
