//
//  MoodMindfulnessViewController.h
//  FitHeart
//
//  Created by Bitgears on 20/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoCaptionParser.h"
#import "GAITrackedViewController.h"

@interface SupportMindfulnessViewController : GAITrackedViewController<VideoCaptionParserDelegate> {
    BOOL _captionsEnabled;
    BOOL captionsChecked;
    UILabel *captionView;
    NSDate *firstCaptionStart;
    NSTimer *captionTimer;
    NSString *captionText;
    int captionState;
    NSArray *captions;
    int captionEnd;
    int captionIndex;


}



@property (strong, nonatomic) IBOutlet UIButton *captionButton;
- (IBAction)captionButtonAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *text1Label;
@property (strong, nonatomic) IBOutlet UILabel *text2Label;

-(void) scheduleNextCaption;

@end
