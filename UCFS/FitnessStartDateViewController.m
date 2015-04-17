//
//  FitnessStartDateViewController.m
//  FitHeart
//
//  Created by Bitgears on 26/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FitnessStartDateViewController.h"
#import "UCFSUtil.h"
#import "FitnessSection.h"
#import "FTAppSettings.h"
#import "FTSalesForce.h"


@interface FitnessStartDateViewController () {
    
    AFPickerView* dayPickerView;
    NSDateFormatter *dateFormatter;
    NSDate *startDate;
}

@end

@implementation FitnessStartDateViewController

@synthesize dateLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentSection = [FitnessSection class];
        dateFormatter = [[NSDateFormatter alloc] init];
        startDate = nil;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                           item:self.navigationItem
                          title:@"START DATE"
                    bkgFileName:[FitnessSection navBarBkg:0]
                      textColor:[UIColor whiteColor]
                 isBackVisibile: NO
     ];
    
    [self setupLeftMenuButton];
    [self setupRightMenuButton];
    
    
    //REMINDER SELECT
    float rowHeight = floor([UCFSUtil contentAreaHeight] / 7);
    float height = rowHeight*7;
    float top = ([UCFSUtil contentAreaHeight] - height) / 2;
    
    dateLabel.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:20.0];
    dateLabel.hidden = YES;
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
    [dayPickerView setAccessibilityHint:@"Tap to select next date, or slide vertically to select previous date."];
    [dayPickerView setAccessibilityValue:[NSString stringWithFormat:@"selected date %@. %i of %i picker items", [self dateToString:(int)(dayPickerView.selectedRow)], (int)(dayPickerView.selectedRow)+1, 7 ]];

    [dayPickerView reloadData];
    dayPickerView.selectedRow = 0;
  
    UIView* bgkView = [[UIView alloc] initWithFrame:CGRectMake(0, rowHeight*3, 320, rowHeight)];
    bgkView.backgroundColor = [FitnessSection mainColor:0];
    
    UIImage* gradientTopImg = [UIImage imageNamed:@"picker_gradient_top"];
    UIImageView* gradientTop = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, gradientTopImg.size.height)];
    [gradientTop setImage:gradientTopImg];
    [gradientTop setUserInteractionEnabled:NO];
    
    UIImage* gradientBottomImg = [UIImage imageNamed:@"picker_gradient_bottom"];
    UIImageView* gradientBottom = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UCFSUtil contentAreaHeight]-gradientBottomImg.size.height, 320, gradientBottomImg.size.height)];
    [gradientBottom setImage:gradientBottomImg];
    [gradientBottom setUserInteractionEnabled:NO];
    
    [self.view addSubview:bgkView];
    [self.view addSubview:dayPickerView];
    [self.view addSubview:gradientBottom];
    [self.view addSubview:gradientTop];
    
    
}


-(void)setupLeftMenuButton{
    self.navigationItem.leftBarButtonItem = [UCFSUtil getNavigationBarCancelButtonWithTarget:self action:@selector(cancelAction:) withSection:currentSection];
}


- (IBAction)cancelAction:(UIButton*)sender {
    
    [self.navigationController popViewControllerAnimated: YES];
}


-(void)setupRightMenuButton{
    self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarSaveButtonWithTarget:self action:@selector(nextAction:) withSection:currentSection];
}



- (IBAction)nextAction:(UIButton*)sender {
    //save star date
    if (startDate==nil) startDate = [NSDate date];
    FTGoalData* goalData = nil;
    goalData = [currentSection goalDataWithType:FITNESS_GOAL_TIME];
    if (goalData!=nil) {
        goalData.goalId = 0; //!!IMPORTANT
        goalData.startDate = startDate;
        [currentSection saveGoalData:goalData];
        [currentSection loadGoals];
    }
    [FTAppSettings setStartNewWeek:NO];

    
    UIViewController* viewController = [UCFSUtil getViewControllerWithSection:SECTION_FITNESS withAction:nil];
    [self.navigationController pushViewController:viewController animated:NO];
    
}

- (NSInteger)numberOfRowsInPickerView:(AFPickerView *)pickerView {
    return 7;
}

-(NSDate*) dateByRow:(NSInteger)row {
    NSDate *date = [NSDate date];
    return [UCFSUtil getDate:date addDays:(int)row];
}

-(NSString*)dateToString:(int)row {
    if (row==0) {
        return @"TODAY";
    }
    else {
        NSDate *date = [self dateByRow:row];
        [dateFormatter setDateFormat:@"EEE MMM dd"];
        return [dateFormatter stringFromDate:date];
        
    }
}

- (NSString *)pickerView:(AFPickerView *)pickerView titleForRow:(NSInteger)row {
    return [self dateToString:(int)row];
}


- (void)pickerView:(AFPickerView *)pickerView didSelectRow:(NSInteger)row {
    startDate = [self dateByRow:row];
    NSString* accValue = [NSString stringWithFormat:@"selected date %@. %i of %i picker items", [self dateToString:(int)row], (int)row+1, 7 ];
    [pickerView setAccessibilityValue:accValue];
    if (UIAccessibilityIsVoiceOverRunning()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, accValue);
        });
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
