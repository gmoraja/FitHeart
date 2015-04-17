//
//  FitnessActivityViewController.m
//  FitHeart
//
//  Created by Bitgears on 27/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FitnessActivityViewController.h"
#import "UCFSUtil.h"
#import "FitnessSection.h"

static NSArray *activities = nil;

@interface FitnessActivityViewController () {
    
    AFPickerView* dayPickerView;
    int currentActivity;
    FTLogData* logData;
    
    UIImageView* gradientTop;
    UIImageView* gradientBottom;
}




@end

@implementation FitnessActivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withLogData:(FTLogData*)log
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentSection = [FitnessSection class];
        currentActivity = log.activity;
        activities = [FitnessSection getActivities];
        logData = log;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.wantsFullScreenLayout = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                           item:self.navigationItem
                          title:@"ACTIVITY"
                    bkgFileName:[FitnessSection navBarBkg:0]
                      textColor:[UIColor whiteColor]
                 isBackVisibile: NO
     ];
    
    [self setupRightMenuButton];
    
    
    
        
    //REMINDER SELECT
    float rowHeight = floor([UCFSUtil contentAreaHeight] / 7);
    float height = rowHeight*7;
    float top = ([UCFSUtil contentAreaHeight] - height) / 2;
    
    CGRect dayPickerRect = CGRectMake(0, top, 320, height);
    dayPickerView = [UCFSUtil initPickerWithFrame:dayPickerRect
                                      withSection:currentSection
                                   withDatasource:self
                                     withDelegate:self
                                         withFont:[UIFont fontWithName:@"SourceSansPro-Regular" size:16.0]
                                    withRowHeight:rowHeight
                                       withIndent:0.0
                                     withAligment:1
                                          withTag:101
                     ];
    dayPickerView.visibleRange = 3;
    
    [dayPickerView setIsAccessibilityElement:YES];
    [dayPickerView setAccessibilityLabel:@"Activity"];
    [dayPickerView setAccessibilityHint:@"Tap to select next activity, or slide vertically to select previous activity."];
    [dayPickerView setAccessibilityValue:[NSString stringWithFormat:@"selected activity %@. %i of %lu picker items", [activities objectAtIndex:dayPickerView.selectedRow], (int)(dayPickerView.selectedRow+1), (unsigned long)[activities count]  ]];

    
    [dayPickerView reloadData];
    dayPickerView.selectedRow = currentActivity;
    
    UIView* bgkView = [[UIView alloc] initWithFrame:CGRectMake(0, rowHeight*3, 320, rowHeight)];
    bgkView.backgroundColor = [FitnessSection mainColor:0];

    UIImage* gradientTopImg = [UIImage imageNamed:@"picker_gradient_top"];
    gradientTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, gradientTopImg.size.height)];
    [gradientTop setImage:gradientTopImg];
    [gradientTop setUserInteractionEnabled:NO];
    
    UIImage* gradientBottomImg = [UIImage imageNamed:@"picker_gradient_bottom"];
    gradientBottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UCFSUtil contentAreaHeight]-gradientBottomImg.size.height, 320, gradientBottomImg.size.height)];
    [gradientBottom setImage:gradientBottomImg];
    [gradientBottom setUserInteractionEnabled:NO];
    
    [self.view addSubview:bgkView];
    [self.view addSubview:dayPickerView];
    [self.view addSubview:gradientBottom];
    [self.view addSubview:gradientTop];
    
    
}


-(void)setupRightMenuButton{
    self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarDoneButtonWithTarget:self action:@selector(doneAction:) withSection:[FitnessSection class]];
}


- (IBAction)doneAction:(UIButton*)sender {
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4f;
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];

    
    [self.navigationController popViewControllerAnimated: NO];
}


- (NSInteger)numberOfRowsInPickerView:(AFPickerView *)pickerView {
    return [activities count];
}

- (NSString *)pickerView:(AFPickerView *)pickerView titleForRow:(NSInteger)row {
    return [activities objectAtIndex:row];
}


- (void)pickerView:(AFPickerView *)pickerView didSelectRow:(NSInteger)row {
    logData.activity = (int)row;
    NSString* accValue = [NSString stringWithFormat:@"selected activity %@. %li of %i picker items", [activities objectAtIndex:row], row+1, (int)[activities count] ];
    [pickerView setAccessibilityValue:accValue];
    /*
    if (UIAccessibilityIsVoiceOverRunning()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, accValue);
        });
    }
     */
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
