//
//  MoodMindfulnessViewController.m
//  FitHeart
//
//  Created by Bitgears on 20/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "SupportMindfulnessViewController.h"
#import "SupportSection.h"
#import "UCFSUtil.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "FTHeaderView.h"
#import "FTTimerHeaderView.h"
#import "MoodSection.h"
#import "FTCircularEntriesGraph.h"
#import <AVFoundation/AVFoundation.h>
#import "VideoCaptionParser.h"
#import "Caption.h"
#import "GFunctor.h"



static float OFFSET_Y = 20;
static float graphRadius = 186;

@interface SupportMindfulnessViewController () {
    //header
    FTTimerHeaderView *headerView;
    //body
    UIView *bodyContainerView;
    FTCircularEntriesGraph *circularGraph;
    UIButton *timerPlayButton;
    UIButton *timerPauseButton;
    UIImage *timerPlayButtonImage;
    UIImage *timerPauseButtonImage;
    
    int automaticButtonState;  //0=start, 1=play, 2=pause
    
    AVAudioPlayer *audioPlayer;
    NSTimer* timer;
    NSTimeInterval timerStartInterval;
    NSTimeInterval timerPausedInterval;
    NSTimeInterval pausedTimeInterval;
    
    NSMutableDictionary *videoCaptions;

    int secCounter;
}

@end

@implementation SupportMindfulnessViewController

@synthesize captionButton;
@synthesize text1Label;
@synthesize text2Label;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        timerPlayButtonImage = [UIImage imageNamed:@"play_btn"];
        timerPauseButtonImage = [UIImage imageNamed:@"pause_btn"];
        

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
                          title:[SupportSection title]
                    bkgFileName:[SupportSection navBarBkg]
                      textColor:[SupportSection navBarTextColor]
                 isBackVisibile: NO
     ];
    
    [self setupLeftMenuButton];
    
    [self initHeader];
    [self initBody];
    [self initAudioPlayer];
    
    text1Label.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16.0];
    text2Label.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16.0];
    
    VideoCaptionParser * parser = [[VideoCaptionParser alloc] init];
    parser.delegate = self;
    [parser loadDataFromXml];
    
    secCounter = 0;
    
    if ([UCFSUtil deviceIs3inch])
        OFFSET_Y  = 60;

    self.screenName = @"Support Mindfulness Screen";

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    

}


-(void)setupLeftMenuButton{
    self.navigationItem.leftBarButtonItem = [UCFSUtil getNavigationBarCancelButtonWithTarget:self action:@selector(backAction:) withTextColor:[SupportSection navBarTextColor]];
}


- (IBAction)backAction:(UIButton*)sender {
    if (audioPlayer!=nil) {
        [audioPlayer stop];
    }
    
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)initHeader {
    float offset_y = 40;
    if ([UCFSUtil deviceSystemIOS7]) offset_y = 0;

    FTHeaderConf *conf = [[FTHeaderConf alloc] initAsTimerValue];
    conf.leftText = @"REMAINING";

    
    CGRect headerRect = CGRectMake(0, offset_y, 320, conf.headerHeight);

    headerView = [[FTTimerHeaderView alloc] initWithFrame:headerRect withConf:conf ];
    headerView.valueMinuteLabel.textColor = [UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1];
    headerView.valueSecondsLabel.textColor = [UIColor colorWithRed:74.0/255.0 green:74.0/255.0 blue:74.0/255.0 alpha:1];
    //headerView.valueSecondsLabel.textColor = [UIColor colorWithRed:118.0/255.0 green:118.0/255.0 blue:118.0/255.0 alpha:1];
    [headerView editMode:FALSE withValueIndex:0];
    [headerView editMode:FALSE withValueIndex:1];
    [self.view addSubview:headerView];
}

- (void)createTimerPlayButton{
    
    float offset_y = OFFSET_Y;
    
    float size = 107;
    
    float availableH = bodyContainerView.frame.size.height - captionButton.frame.size.height;
    
    CGRect rect = CGRectMake((bodyContainerView.frame.size.width-size)/2, (availableH-size)/2+offset_y, size, size);
    
    timerPlayButton = [[UIButton alloc] initWithFrame:rect];
    [timerPlayButton setBackgroundImage:timerPlayButtonImage forState:UIControlStateNormal];
    [timerPlayButton addTarget:self action:@selector(playTimer:) forControlEvents:UIControlEventTouchUpInside];
    timerPlayButton.hidden = NO;
    [timerPlayButton setAccessibilityLabel:@"Play"];
    [timerPlayButton setAccessibilityHint:@"Tap to play audio"];
    
    [bodyContainerView addSubview:timerPlayButton];
    
}

- (void)createTimerPauseButton{
    
    float offset_y = OFFSET_Y;
    
    float size = 107;
    
    float availableH = bodyContainerView.frame.size.height - captionButton.frame.size.height;
    
    CGRect rect = CGRectMake((bodyContainerView.frame.size.width-size)/2, (availableH-size)/2+offset_y, size, size);
    
    timerPauseButton = [[UIButton alloc] initWithFrame:rect];
    [timerPauseButton setBackgroundImage:timerPauseButtonImage forState:UIControlStateNormal];
    [timerPauseButton addTarget:self action:@selector(pauseTimer:) forControlEvents:UIControlEventTouchUpInside];
    timerPauseButton.hidden = YES;
    [timerPauseButton setAccessibilityLabel:@"Pause"];
    [timerPauseButton setAccessibilityHint:@"Tap to pause audio"];
    
    [bodyContainerView addSubview:timerPauseButton ];
    
}

- (void)initBody {
    float bodyContainerViewH = [UCFSUtil contentAreaHeight] - (headerView.frame.origin.y+headerView.frame.size.height) - captionButton.frame.size.height;
    CGRect bodyContainerRect = CGRectMake(0, headerView.frame.origin.y+headerView.frame.size.height, 320, bodyContainerViewH);
    bodyContainerView = [[UIView alloc] initWithFrame:bodyContainerRect];
    bodyContainerView.backgroundColor = [UIColor clearColor];
    
    float w = graphRadius;
    float h = graphRadius;
    float space_y = 40;
    if ([UCFSUtil deviceIs3inch])
        space_y = 20;

    float availableH = bodyContainerView.frame.size.height - captionButton.frame.size.height;
    
    CGRect circularEntriesGraphFrame = CGRectMake((bodyContainerView.frame.size.width-w)/2, (availableH-h)/2+OFFSET_Y, w, h);
    circularGraph = [[FTCircularEntriesGraph alloc] initWithFrame:circularEntriesGraphFrame
                                                              withRadius:65
                                                                withSize:12
                            ];
    circularGraph.wheelForegroundColor = [UIColor colorWithRed:245.0/255.0 green:166.0/255.0 blue:35.0/255.0 alpha:1.0];
    circularGraph.wheelBackgroundColor = [UIColor colorWithRed:207.0/255.0 green:207.0/255.0 blue:207.0/255.0 alpha:1.0];
    [circularGraph resetWithProgress:0 withValue:0 withUnit:@""];
    
    [circularGraph setIsAccessibilityElement:YES];
    //NSString* endStr = [UCFSUtil stringWithValueAsTime:110];
    [circularGraph resetWithProgress:0 withValue:0 withUnit:@""];
    [circularGraph setAccessibilityLabel:[self timeToString:0 withElapsed:YES]];
    
    [bodyContainerView addSubview:circularGraph];
    [self createTimerPlayButton];
    [self createTimerPauseButton];
    
    
    [self.view addSubview:bodyContainerView];
}

-(void)initAudioPlayer {
    NSString *filename = [NSString stringWithFormat:@"%@/lilac_breath_awareness.mp3", [[NSBundle mainBundle] resourcePath]];
    NSURL *url = [NSURL fileURLWithPath:filename];
	
	NSError *error;
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	audioPlayer.numberOfLoops = 0;
    [headerView updateHeaderWithTime:audioPlayer.duration];
    //NSString* endStr = [UCFSUtil stringWithValueAsTime:audioPlayer.duration];
    
    [circularGraph resetWithProgress:0 withValue:0 withUnit:@""];
    automaticButtonState = 0;
	
}

- (IBAction)startTimer:(id)sender {
    //[self updateUIWithHours:0 withMinutes:0 withSeconds:0];
     [audioPlayer play];
    automaticButtonState = 1; //playing
    timerStartInterval = [[NSDate date] timeIntervalSince1970];
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    timerPauseButton.hidden = NO;
    timerPlayButton.hidden = YES;
    
}

- (IBAction)stopTimer:(id)sender {
    if (timer!=nil && [timer isValid]) {
        [timer invalidate];
    }
    timer = nil;
    timerPauseButton.hidden = YES;
    timerPlayButton.hidden = NO;
    [audioPlayer stop];
    automaticButtonState = 0;
    
    [self setCaptionsEnabled:FALSE];

    
}


- (IBAction)pauseTimer:(id)sender {
    if ([timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
    
    pausedTimeInterval = [[NSDate date] timeIntervalSince1970];
    
    timerPausedInterval = [[NSDate date] timeIntervalSince1970]-timerStartInterval;
    
    automaticButtonState = 2; //paused
    timerPauseButton.hidden = YES;
    timerPlayButton.hidden = NO;
    [audioPlayer pause];
    automaticButtonState = 2;
    
    [self setCaptionsEnabled:FALSE];
    text1Label.hidden = NO;
    text2Label.hidden = NO;


}

- (IBAction)playTimer:(id)sender {
    [audioPlayer play];
    BOOL wasPaused = (automaticButtonState==2);
    automaticButtonState = 1; //playing
    timerStartInterval = [[NSDate date] timeIntervalSince1970]-timerPausedInterval;
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    timerPauseButton.hidden = NO;
    timerPlayButton.hidden = YES;
    text1Label.hidden = YES;
    text2Label.hidden = YES;
    
    
    if (wasPaused) {
        [self setCaptionsEnabled:YES];
        NSTimeInterval delay = [[NSDate date] timeIntervalSince1970]-pausedTimeInterval;
        firstCaptionStart = [firstCaptionStart dateByAddingTimeInterval:delay];
        [self scheduleNextCaption];
    }
    else {
        if ([captions count] >0 ) {
            captionIndex = 0;
            firstCaptionStart = [NSDate date];
            
            [self scheduleNextCaption];
        }
    }

    

}


-(NSString*)timeToString:(int)time withElapsed:(BOOL)elapsed {
    int minutes = trunc(time / 60);
    int seconds = time - (minutes*60);
    if (elapsed)
        return [NSString stringWithFormat:@"elapsed %i minutes %i seconds", minutes, seconds];
    else
        return [NSString stringWithFormat:@"%i minutes %i seconds", minutes, seconds];
}




- (void)timerFireMethod:(NSTimer *)timer {
    if (audioPlayer != nil) {
        int remaining = audioPlayer.duration - audioPlayer.currentTime;
        if (audioPlayer.isPlaying) {
            [headerView updateHeaderWithTime:remaining];
                              
            [circularGraph resetWithProgress:(float)(audioPlayer.currentTime) withValue:(float)(audioPlayer.duration) withUnit:@""];
            [circularGraph setAccessibilityLabel:[self timeToString:audioPlayer.currentTime withElapsed:YES]];
            [circularGraph setNeedsDisplay];
        }
        else {
            [self stopTimer:nil];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)xmlParseCompleted:(NSMutableDictionary *)parsedCaptions{
    
    videoCaptions = [[NSMutableDictionary alloc] initWithDictionary:parsedCaptions];

    captions = [videoCaptions objectForKey:@"Mindfulness_Close_Captions_2"];

}

-(void) scheduleNextCaption {
    if (!captions) return;
    if (captionIndex >= captions.count) {
        // No more captions
        if (captionTimer) {
            [captionTimer invalidate];
             captionTimer = nil;
        }
        return;
    }
    
    if (!captionView) {
        UIFont *font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16.0];
        
        float height = 137;
        float y = bodyContainerView.frame.size.height-captionButton.frame.size.height-50;
        CGRect r = CGRectMake(20, y, 280, height);
        captionView = [[UILabel alloc] initWithFrame:r];
        captionView.textAlignment = NSTextAlignmentCenter;
        captionView.textColor = [UIColor whiteColor];
        //captionView.textColor = [UIColor blackColor];
        captionView.font = font;
        //captionView.shadowColor = [UIColor blackColor];
        //captionView.shadowOffset = CGSizeMake(1, 1);
        captionView.numberOfLines = 10;
        captionView.lineBreakMode = NSLineBreakByWordWrapping;
        captionView.userInteractionEnabled = FALSE;
        captionView.contentMode = UIViewContentModeCenter;
        captionView.backgroundColor = [UIColor colorWithRed:119.0/255.0 green:119.0/255.0 blue:119.0/255.0 alpha:1];
        captionView.layer.cornerRadius = 10;
        captionView.alpha = 0;
        [bodyContainerView addSubview:captionView];
    } else {
        captionView.alpha = 0;
    }
    
    captionState=0;
    
    NSObject *caption = [captions objectAtIndex:captionIndex];
    /*
     NSEntityDescription *attDesc = [caption entity];
     NSDictionary *attributesByName = [attDesc attributesByName];
     NSLog(@"Names:%@",[attributesByName allKeys]);
     */
    int startMs = [[caption valueForKey:@"start"] intValue];
    captionEnd = [[caption valueForKey:@"end"] intValue];
	NSDate *startDate = [NSDate dateWithTimeInterval:startMs/1000.0f sinceDate:firstCaptionStart];
    captionText = [caption valueForKey:@"mainText"];

    __block SupportMindfulnessViewController *weakSelf = self;

    
    captionIndex++;
    
    if (captionTimer) {
        [captionTimer setFireDate:startDate];
    } else {
        GFunctor *f = [[GFunctor alloc] initWithBlock:^{
            secCounter++;
            if ([weakSelf captionState] == 0) {
                secCounter = 0;
                // caption start
                NSLog(@"%@\n",[weakSelf captionText]);
                [weakSelf showCaption];
                [[weakSelf captionTimer] setFireDate:[weakSelf captionEnd]];
            } else {
                // caption end
                NSLog(@"(done)\n");
                [weakSelf hideCaption];
            }
        }];
        captionTimer = [[NSTimer alloc] initWithFireDate:(NSDate *)startDate interval:10000 target:f selector:@selector(invoke) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:captionTimer forMode:NSRunLoopCommonModes];
    }
    
}

-(NSTimer*) captionTimer {
    return captionTimer;
}

-(int) captionIndex {
    return captionIndex;
}

-(int) captionState {
    return captionState;
}

-(NSString*) captionText {
    return captionText;
}

-(UILabel*) captionView {
    return captionView;
}

-(NSDate*) captionEnd {
    return [NSDate dateWithTimeInterval:captionEnd/1000.0f sinceDate:firstCaptionStart];
}

-(void) setCaptionState:(int)state {
    captionState = state;
}

-(void) showCaption {
    CGSize size = [captionText sizeWithFont:captionView.font constrainedToSize:CGSizeMake(captionView.frame.size.width, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    captionView.text = captionText;
    captionView.isAccessibilityElement = YES;
    captionView.accessibilityLabel = captionText;
    CGRect r = captionView.frame;
    //float bottom = r.origin.y + r.size.height;
    //r.origin.y = bottom - size.height - 20;
    CGFloat marginBottom = 180;
    if ([UCFSUtil deviceIs3inch])
        marginBottom = 150;
    r.origin.y = self.view.frame.size.height - size.height - marginBottom; //show hide button height
    r.size.height = size.height + 20;
    captionView.frame = r;
    captionState = 1;
    
    if (self.captionsEnabled) {
        if (UIAccessibilityIsVoiceOverRunning())
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, captionText);
        //UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification, captionView);
        [UIView beginAnimations:@"showCaption" context:nil];
        [UIView setAnimationDuration:0.5];
        captionView.alpha = 1;
        [UIView commitAnimations];
    }
}

-(void) hideCaption {
    if (self.captionsEnabled) {
        [UIView beginAnimations:@"hideCaption" context:nil];
        [UIView setAnimationDuration:0.5];
        captionView.alpha = 0;
        [UIView commitAnimations];
    }
    if (automaticButtonState!=2)
        [self scheduleNextCaption];
}

-(BOOL)captionsEnabled {
    return _captionsEnabled;
}

-(void)setCaptionsEnabled:(BOOL)on {
    if (_captionsEnabled == on) return;
    if (!on) {
        _captionsEnabled = FALSE;
        if (captionState) captionView.alpha = 0;
    } else {
        _captionsEnabled = TRUE;
        if (captionState) captionView.alpha = 1;
    }
}


- (IBAction)captionButtonAction:(id)sender {
    if (_captionsEnabled) {
        [self setCaptionsEnabled:FALSE];
        [captionButton setAccessibilityLabel:@"Enable captions"];
        [captionButton setAccessibilityValue:@"Captions disabled"];
    }
    else {
        [self setCaptionsEnabled:TRUE];
        [captionButton setAccessibilityLabel:@"Disable captions"];
        [captionButton setAccessibilityValue:@"Captions enabled"];
    }
}



@end
