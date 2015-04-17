//
//  FitnessAfterGoalViewController.m
//  FitHeart
//
//  Created by Bitgears on 27/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FitnessAfterGoalViewController.h"
#import "UCFSUtil.h"
#import "FTAppSettings.h"
#import "FitnessSection.h"
#import "FitnessHomeViewController.h"
#import "FTHowDoYouFeelViewController.h"


static NSArray *congratulatoryMessageGoalReached = nil;
static NSArray *congratulatoryMessageGoalNotReached = nil;
static NSArray *educationMessageGoalReached = nil;
static NSArray *educationMessageGoalNotReached = nil;

@interface FitnessAfterGoalViewController () {
    
    BOOL isReached;
    BOOL isEndOfWeek;
}

@end

@implementation FitnessAfterGoalViewController

@synthesize titleLabel;
@synthesize subTitleLabel;
@synthesize goalreachedImageView;
@synthesize continueButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil asReached:(BOOL)reached asEndOfWeek:(BOOL)endOfWeek
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isReached = reached;
        isEndOfWeek = endOfWeek;
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
                          title:@"FITNESS"
                    bkgFileName:[FitnessSection navBarBkg:0]
                      textColor:[UIColor whiteColor]
                 isBackVisibile: NO
     ];
    
    titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:24.0];
    titleLabel.textColor = [FitnessSection mainColor:0];
    subTitleLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:21.0];
    
    float totalHeight = [UCFSUtil contentAreaHeight] - continueButton.frame.size.height;
    float offsetY = 0;
    if ([UCFSUtil deviceSystemIOS7]==false) offsetY = 44;

    if (isReached) {
        
        //center
        goalreachedImageView.hidden = NO;
        CGRect newImageFrame = CGRectMake((320-goalreachedImageView.frame.size.width)/2, offsetY + (totalHeight-goalreachedImageView.frame.size.height)/2, goalreachedImageView.frame.size.width, goalreachedImageView.frame.size.height);
        goalreachedImageView.frame = newImageFrame;

        
        titleLabel.text = [FitnessAfterGoalViewController getCongratulatoryMessageGoalReached];
        float y =  (goalreachedImageView.frame.origin.y + offsetY - titleLabel.frame.size.height) / 2;
        CGRect newTitleFrame = CGRectMake((320-titleLabel.frame.size.width)/2, y, titleLabel.frame.size.width, titleLabel.frame.size.height);
        titleLabel.frame = newTitleFrame;

        subTitleLabel.text = [FitnessAfterGoalViewController getEducationMessageGoalReached];
        [subTitleLabel sizeToFit];
        float spaceY = (totalHeight-(goalreachedImageView.frame.origin.y + goalreachedImageView.frame.size.height));
        y = (goalreachedImageView.frame.origin.y + goalreachedImageView.frame.size.height) + (spaceY+offsetY-subTitleLabel.frame.size.height)/2;
        CGRect newFrame = CGRectMake((320-subTitleLabel.frame.size.width)/2, y, subTitleLabel.frame.size.width, subTitleLabel.frame.size.height);
        subTitleLabel.frame = newFrame;
        
        
    }
    else {
        goalreachedImageView.hidden = YES;
        CGRect newImageFrame = CGRectMake((320-goalreachedImageView.frame.size.width)/2, offsetY + (totalHeight-goalreachedImageView.frame.size.height)/2, goalreachedImageView.frame.size.width, goalreachedImageView.frame.size.height);
        goalreachedImageView.frame = newImageFrame;
        
        
        titleLabel.text = [FitnessAfterGoalViewController getCongratulatoryMessageGoalNotReached];
        float y =  offsetY+ (goalreachedImageView.frame.origin.y - titleLabel.frame.size.height) / 2;
        CGRect newTitleFrame = CGRectMake((320-titleLabel.frame.size.width)/2, y, titleLabel.frame.size.width, titleLabel.frame.size.height);
        titleLabel.frame = newTitleFrame;
        
        subTitleLabel.text = [FitnessAfterGoalViewController getEducationMessageGoalNotReached];
        [subTitleLabel sizeToFit];
        y = offsetY+ (totalHeight-subTitleLabel.frame.size.height)/2;
        CGRect newFrame = CGRectMake((320-subTitleLabel.frame.size.width)/2, y, subTitleLabel.frame.size.width, subTitleLabel.frame.size.height);
        subTitleLabel.frame = newFrame;
        
        goalreachedImageView.hidden = YES;
    }
    
    if (isEndOfWeek) {
        [continueButton setTitle:@"HOW DO YOU FEEL?" forState:UIControlStateNormal];
        [UCFSUtil trackGAEventWithCategory:@"ui_action" withAction:@"fitness_end_of_week" withLabel:(isReached?@"reached goal":@"not reached goal") withValue:[NSNumber numberWithInt:1]];

    }
    else {
        [continueButton setTitle:@"CONTINUE" forState:UIControlStateNormal];
        [UCFSUtil trackGAEventWithCategory:@"ui_action" withAction:@"fitness_end_of_week" withLabel:(isReached?@"reached goal":@"not reached goal") withValue:[NSNumber numberWithInt:1]];

        
    }
    
    [UCFSUtil trackGAEventWithCategory:@"ui_action" withAction:@"fitness_end_goal" withLabel:@"screen" withValue:[NSNumber numberWithInt:1]];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)continueButtonAction:(id)sender {
    if (isEndOfWeek) {
        UIViewController* viewController = [[FTHowDoYouFeelViewController alloc] initWithNibName:@"FitnessHowDoYouFeelView" bundle:nil withSection:[FitnessSection class]];
        [self.navigationController pushViewController:viewController animated:NO];
    }
    else {
        //find HomeViewController
        UIViewController* homeViewController = nil;
        NSArray *viewControllers = [self.navigationController viewControllers];
        if (viewControllers!=nil) {
            for (int i=0; i<[viewControllers count]; i++) {
                UIViewController* temp = (UIViewController*)[viewControllers objectAtIndex:i];
                if ([temp isMemberOfClass:[FitnessHomeViewController class]]) {
                    homeViewController = temp;
                    break;
                }
            }
        }
        
        //pop to HomeViewController
        if (homeViewController!=nil) {
            [self.navigationController popToViewController:homeViewController animated:NO];
        }
        else
            [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
    
}


+ (NSString*)getCongratulatoryMessageGoalNotReached {
    if (congratulatoryMessageGoalNotReached==nil) {
        congratulatoryMessageGoalNotReached = [[NSArray alloc] initWithObjects:
                                            @"Well done!",
                                            @"Way to go!",
                                            @"Keep it up!",
                                            @"Nice job!",
                                            nil
                                            ];
    }
    
    int index = [FTAppSettings getCongratMsgGoalNotReachedIndex];
    index++;
    if (index>=[congratulatoryMessageGoalNotReached count])
        index = 0;
    [FTAppSettings setCongratMsgGoalNotReachedIndex:index];
    
    return congratulatoryMessageGoalNotReached[index];
    
}


+ (NSString*)getCongratulatoryMessageGoalReached {
    if (congratulatoryMessageGoalReached==nil) {
        congratulatoryMessageGoalReached = [[NSArray alloc] initWithObjects:
                        @"Amazing job!",
                        @"Fantastic!",
                        @"Awesome!",
                        @"You did it!",
                        @"Excellent!",
                        @"Congratulations!",
                        nil
                        ];
    }
    
    int index = [FTAppSettings getCongratMsgGoalReachedIndex];
    index++;
    if (index>=[congratulatoryMessageGoalReached count])
        index = 0;
    [FTAppSettings setCongratMsgGoalReachedIndex:index];
    
    return congratulatoryMessageGoalReached[index];
    
}

+ (NSString*)getEducationMessageGoalNotReached {
    if (educationMessageGoalNotReached==nil) {
        educationMessageGoalNotReached = [[NSArray alloc] initWithObjects:
                                          @"Safety first! Let your doctor know if you have chest pain or trouble breathing.",
                                          @"Being active is an important part of heart health.",
                                          @"A healthy diet can reduce your risk of heart problems.",
                                          @"SMART goals are Specific, Measureable, Attainable, Relevant, and Timely.",
                                          @"Try to replace junk foods like chips and sweets with vegetables and fruits!",
                                          @"Try to get at least 150 minutes/week of physical activity.",
                                          @"Try to include 4-5 servings of fruits and vegetables in your daily diet.",
                                          @"Choose oil-based salad dressings (Italian) over the creamier options (Ranch).",
                                          @"Pushing yourself to work up a sweat can improve your heart health.",
                                          @"Limit your portion sizes and salt intake, and try to avoid high fat and sugary foods.",
                                          @"It can help to have a fitness buddy. Do you have friends or family who can help?",
                                          @"Engaging in at least moderate intensity activities is best for your heart.",
                                          @"Drink less than 36 ounces/week of sugary beverages (like soda or juice).",
                                          @"Use olive oil to cook instead of butter.",
                                          @"Being active can improve your health and mood. Plus, it’s fun!",
                                          @"Taking the stairs or parking your car far away can help increase physical activity.",
                                          @"Did you know that red meats have more unhealthy fat than chicken and fish?",
                                          @"Beans, peas, lentils, and nuts are excellent sources of protein, vitamins, and fiber.",
                                          @"Whole grains contain fiber, which helps control cholesterol and glucose levels!",
                                          @"Varying your fitness routine can help keep you engaged.",
                                          @"Egg whites contain protein while the yolk has fat. Limit yolks to two per week.",
                                          @"Salt makes your heart work harder. Eat less salt to lower your blood pressure.",
                                          @"Setting goals can help you stay healthy. Are you meeting your fitness goals?",
                                          @"Remember, both good diet and exercise will help you stay healthy!",
                                          @"Did you know that people who are more physically active live longer?",
                                          @"You can count how many steps you take in a day to measure your activity.",
                                          @"If you are overweight, losing weight is an important step towards better health.",
                                          @"Try to eat 3 or more servings of whole grains (oats, brown rice, barley) per day.",
                                          @"Reducing sedentary time (like watching TV) can improve your health.",
                                          @"Making a plan to stay active over the long-term can help you to stay healthy.",
                                          @"Look at nutrition labels on foods to make healthy food choices.",
                                          nil
                                               ];
    }
    
    int index = [FTAppSettings getEducationMsgGoalNotReachedIndex];
    index++;
    if (index>=[educationMessageGoalNotReached count])
        index = 0;
    [FTAppSettings setEducationMsgGoalNotReachedIndex:index];
    
    return educationMessageGoalNotReached[index];
    
}

+ (NSString*)getEducationMessageGoalReached {
    if (educationMessageGoalReached==nil) {
        educationMessageGoalReached = [[NSArray alloc] initWithObjects:
                                       @"You reached your goal!",
                                       @"You’re taking an important step to improve your heart health.",
                                       @"Keep up the good work by being active on most days.",
                                       @"Reward yourself for a job well done.",
                                       @"Reaching your goals can help improve your mood.",
                                       @"Remember what you did to help you achieve your goal to use in the future. ",
                                       @"Share your good news with family and friends.",
                                       @"Think about ways that you can do a little bit more next week.",
                                       @"Being active can improve your health and mood. Plus, it’s fun!",
                                       @"Make a commitment to staying active.",
                                       @"Vary your fitness routine to help keep you engaged.",
                                       @"Staying active is important for a healthy heart.",
                                       @"Make a plan to stay active long-term.",
                                       @"Continue to set new goals and stay active!",
                                       @"To reduce stay engaged, consider switching between different forms of exercise.",
                                       @"Congratulations on your achievement!",
                                       @"Motivate others to be active with you.",
                                       @"Noticing how good exercise makes you feel can motivate you in the future.",
                                       @"Great job! Remember, regular exercise is crucial for good health.",
                                       @"You have taken a step towards a healthier lifestyle. Celebrate your achievement.",
                                          nil
                                          ];
    }
    
    int index = [FTAppSettings getEducationMsgGoalReachedIndex];
    index++;
    if (index>=[educationMessageGoalReached count])
        index = 0;
    [FTAppSettings setEducationMsgGoalReachedIndex:index];
    
    return educationMessageGoalReached[index];
    
}




@end
