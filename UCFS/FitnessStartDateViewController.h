//
//  FitnessStartDateViewController.h
//  FitHeart
//
//  Created by Bitgears on 26/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTSection.h"
#import "AFPickerView.h"


@interface FitnessStartDateViewController : UIViewController<AFPickerViewDelegate, AFPickerViewDataSource> {
    Class<FTSection> currentSection;
}

@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end
