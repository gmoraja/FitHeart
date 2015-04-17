//
//  EulaViewController.h
//  UCFS
//
//  Created by Bitgears on 30/10/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"


@interface EulaViewController : GAITrackedViewController {
    
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *footerImageView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UILabel *contentText1Label;
@property (strong, nonatomic) IBOutlet UILabel *contentText2Label;
@property (strong, nonatomic) IBOutlet UILabel *contentText3Label;
@property (strong, nonatomic) IBOutlet UIButton *iagreeButton;
@property (strong, nonatomic) IBOutlet UIImageView *maskImageView;
@property (strong, nonatomic) IBOutlet UILabel *actionLabel;
- (IBAction)iagreeAction:(id)sender;

@end
