//
//  StudyIdViewController.h
//  UCFS
//
//  Created by Bitgears on 31/10/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StudyIdViewController : UIViewController<UITextFieldDelegate> {
}


@property (strong, nonatomic) IBOutlet UIImageView *footerImageView;
@property (strong, nonatomic) IBOutlet UIButton *submitButton;
- (IBAction)submitAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) IBOutlet UITextField *studyIdTextField;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;

@end
