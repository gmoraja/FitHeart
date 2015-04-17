//
//  FitnessReminderViewController.h
//  FitHeart
//
//  Created by Bitgears on 26/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTSection.h"
#import "FTFrequencySlider.h"
#import "AFPickerView.h"

@interface FTReminderViewController : UIViewController<FTFrequencySliderDelegate, AFPickerViewDataSource, AFPickerViewDelegate> {
     Class<FTSection> currentSection;
}
@property (strong, nonatomic) IBOutlet UILabel *reminderLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSection:(Class<FTSection>)section withReminder:(FTReminderData*)reminder withEditMode:(BOOL)edit;

@end
