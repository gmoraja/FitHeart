//
//  MoodAddNoteViewController.h
//  FitHeart
//
//  Created by Bitgears on 23/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTDialogView.h"
#import "FTNoteData.h"
#import "FTOptionGroupView.h"


@interface MoodAddNoteViewController : UIViewController<FTDialogDelegate, FTOptionGroupProtocol, UITextViewDelegate> {
        FTNoteData* note;
        bool isEdit;
        bool isSimplePleasure;
}


@property (strong, nonatomic) IBOutlet UITextView *noteTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSimplePleasure:(bool)sp;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSimplePleasure:(bool)sp withNote:(FTNoteData*)noteData;

@end
