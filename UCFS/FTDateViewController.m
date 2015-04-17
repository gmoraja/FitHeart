//
//  FitnessDateViewController.m
//  FitHeart
//
//  Created by Bitgears on 27/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FTDateViewController.h"
#import "UCFSUtil.h"
#import "FitnessSection.h"

@interface FTDateViewController () {
    
    AFPickerView* dayPickerView;
    NSDateFormatter *dateFormatter;
    NSDate* startDate;
    FTLogData* logData;
    
    int numDays;
}


@end

@implementation FTDateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withStartDate:(NSDate*)date withLogData:(FTLogData*)log withSection:(Class<FTSection>)section
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        currentSection = section;
        dateFormatter = [[NSDateFormatter alloc] init];
        startDate = date;
        logData = log;
        if ([currentSection sectionType]==SECTION_FITNESS) {
            if ([FitnessSection checkWeekIsOverWithStartDate:startDate]) {
                numDays = 7;
                //startDate = [UCFSUtil getDate:startDate addDays:6];
            }
            else
                numDays = (int)[UCFSUtil daysBetween:startDate and:[NSDate date]];
        }
        else
            numDays = (int)[UCFSUtil daysBetween:startDate and:[NSDate date]];
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
                          title:@"DATE"
                    bkgFileName:[currentSection navBarBkg:0]
                      textColor:[currentSection navBarTextColor:0]
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
    [dayPickerView reloadData];
    dayPickerView.selectedRow = numDays-1;
    [dayPickerView setAccessibilityLabel:@"Date"];
    [dayPickerView setAccessibilityHint:@"Tap to select next date"];
    [dayPickerView setAccessibilityValue:[NSString stringWithFormat:@"selected date %@", [self dateToString:logData.insertDate] ]];
    
    UIView* bgkView = [[UIView alloc] initWithFrame:CGRectMake(0, rowHeight*3, 320, rowHeight)];
    bgkView.backgroundColor = [currentSection mainColor:0];
    
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


-(void)setupRightMenuButton{
    self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarDoneButtonWithTarget:self action:@selector(doneAction:) withSection:currentSection];
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
    return numDays;
}

-(NSDate*) dateByRow:(NSInteger)row {
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = row;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dayComponent toDate:startDate options:0];
    
}

-(NSString*)dateToString:(NSDate*)date {
    [dateFormatter setDateFormat:@"EEE MMM dd"];
    return [dateFormatter stringFromDate:date];
    
}

- (NSString *)pickerView:(AFPickerView *)pickerView titleForRow:(NSInteger)row {
        NSDate *date = [self dateByRow:row];
        return [self dateToString:date];
}


- (void)pickerView:(AFPickerView *)pickerView didSelectRow:(NSInteger)row {
    logData.insertDate = [self dateByRow:row];
    [pickerView setAccessibilityValue:[NSString stringWithFormat:@"selected date %@", [self dateToString:logData.insertDate] ]];

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
