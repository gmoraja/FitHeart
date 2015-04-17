//
//  StudyIdViewController.m
//  UCFS
//
//  Created by Bitgears on 31/10/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "StudyIdViewController.h"
#import "StudyIdSection.h"
#import "OrientationViewController.h"
#import "AFPickerView.h"
#import "UCFSUtil.h"
#import "FTAppSettings.h"
#import "FTSalesForce.h"

@interface StudyIdViewController () {
    NSString* lastEntered;
}

@end

@implementation StudyIdViewController


@synthesize footerImageView;
@synthesize submitButton;
@synthesize errorLabel;
@synthesize studyIdTextField;
@synthesize subTitleLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        lastEntered = @"";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.wantsFullScreenLayout = YES;
    [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                           item:self.navigationItem     
                          title:[StudyIdSection title]
                    bkgFileName:[StudyIdSection navBarBkg]
                      textColor:[UIColor blackColor]
                 isBackVisibile: NO
     ];

    
    errorLabel.hidden = YES;

    footerImageView.backgroundColor = [StudyIdSection footerColor];
    submitButton.backgroundColor = [StudyIdSection lightColor];
    submitButton.hidden = YES;

    submitButton.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:20.0];
    studyIdTextField.delegate = self;
    [studyIdTextField setReturnKeyType:UIReturnKeyGo];
    //
    /*
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"GO" style:UIBarButtonItemStyleDone target:self action:@selector(goButtonAction)],
                           nil];
    [numberToolbar sizeToFit];
    studyIdTextField.inputAccessoryView = numberToolbar;
     */

    
    subTitleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16.0];
    errorLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16.0];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction)];
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    
    [studyIdTextField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    
    [self.navigationItem setRightBarButtonItem:[UCFSUtil getNavigationBarGoButtonWithTarget:self action:@selector(submitAction:) withTextColor:[UIColor blackColor] ] ];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self textStyle:studyIdTextField];
    [studyIdTextField becomeFirstResponder];
}

-(IBAction)textFieldDidChange:(id)sender {
    
    if ( [studyIdTextField.text length]!=[lastEntered length] ) {
        lastEntered = studyIdTextField.text;
        [self textStyle:studyIdTextField];
    }

    /*
    if ([studyIdTextField.text length]==4) {
        int studyId = [studyIdTextField.text intValue];
        [self submitCode:studyId];
    }
     */
 
}

- (void) textStyle:(UITextField*)textField {
    
    if (textField!=nil && textField.text!=nil) {
        //NSLog(@"%@", textField.text);
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textField.text];
        [attributedString addAttribute:NSKernAttributeName value:@(26) range:NSMakeRange(0, textField.text.length)];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"SourceSansPro-Semibold" size:52.0] range:NSMakeRange(0, textField.text.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.0/255.0 green:108.0/255.0 blue:136.0/255.0 alpha:1.0] range:NSMakeRange(0, textField.text.length)];
        //[attributedString addAttribute:NSWritingDirectionAttributeName value:@[@(NSWritingDirectionLeftToRight | NSTextWritingDirectionOverride)] range:NSMakeRange(0, textField.text.length)];
        
        textField.attributedText = attributedString;
        
    }
    
}

- (void) animateTextField: (UITextField*)textField up:(BOOL)up
{
    const int movementDistance = 40; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    textField.frame = CGRectOffset(textField.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self clearError];
    [textField becomeFirstResponder];
    if ([UCFSUtil deviceIs3inch])
        [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    if ([UCFSUtil deviceIs3inch])
        [self animateTextField: textField up: NO];

}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    
    if  ( (string.length>0 && textField.text.length<=3) ||
          (string.length==0) ){
        
        float value = [textField.text floatValue];
        if (value>=0 && value<=9999 && range.location<=3) {
            return true;
        }
        
        
    }
        
    return false;
}


-(IBAction)singleTapAction{
    
    [studyIdTextField resignFirstResponder];
}

-(IBAction)goButtonAction{
    
    [studyIdTextField resignFirstResponder];
    [self submitCode];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)codeIsCorrect {
    NSString* studyIdStr = studyIdTextField.text;
    if (studyIdStr!=nil && [studyIdStr length]==4)
        return YES;
    else
        return NO;
}

- (void)submitCode {
    int studyId = [studyIdTextField.text intValue];
    if ([self codeIsCorrect]) {
        
        [FTAppSettings setStudyId:studyId];
        [FTAppSettings confirmStudyId];
        
        CATransition* transition = [CATransition animation];
        transition.duration = 0.4f;
        transition.type = kCATransitionMoveIn;
        transition.subtype = kCATransitionFromTop;
        [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
        
        OrientationViewController *viewController = [[OrientationViewController alloc] initWithNibName:@"OrientationView" bundle:nil];
        [self.navigationController pushViewController:viewController animated:NO];
    }
    else {
        errorLabel.hidden = NO;
        submitButton.layer.borderWidth = 2;
        submitButton.layer.borderColor = [UIColor redColor].CGColor;
    }
}

-(void)clearError {
    errorLabel.hidden = YES;
    submitButton.layer.borderWidth = 2;
    submitButton.layer.borderColor = [UIColor clearColor].CGColor;
}

- (IBAction)submitAction:(id)sender {
    [self submitCode];
}


@end
