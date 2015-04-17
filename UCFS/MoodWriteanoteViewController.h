//
//  MoodWriteanoteViewController.h
//  FitHeart
//
//  Created by Bitgears on 23/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoodNoteView.h"
#import "FTDialogView.h"

@interface MoodWriteanoteViewController : UIViewController<MoodNoteDelegate, FTDialogDelegate>

@property (strong, nonatomic) IBOutlet UILabel *firstUseLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *contentScrollView;


@end
