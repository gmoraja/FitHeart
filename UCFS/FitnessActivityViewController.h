//
//  FitnessActivityViewController.h
//  FitHeart
//
//  Created by Bitgears on 27/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTSection.h"
#import "AFPickerView.h"

@interface FitnessActivityViewController : UIViewController<AFPickerViewDelegate, AFPickerViewDataSource> {
    Class<FTSection> currentSection;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withLogData:(FTLogData*)log;

@end
