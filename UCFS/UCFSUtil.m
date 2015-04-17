//
//  UCFSUtil.m
//  FitHeart
//
//  Created by Bitgears on 11/11/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "UCFSUtil.h"
#import "FTSection.h"
#import "FitnessSection.h"
#import "HealthSection.h"
#import "MoodSection.h"
#import "TBCircularSlider.h"
#import "FTFrequencySlider.h"
#import "AFPickerView.h"
#import "FTCircularTimerSlider.h"
#import "FitnessHomeViewController.h"
#import "HealthHomeViewController.h"
#import "NutritionHomeViewController.h"
#import "MoodHomeViewController.h"
#import "FTNoteHeader.h"
#import "FTNote.h"
#import "FTNotification.h"
#import "FTNotificationManager.h"
#import "StudyIdViewController.h"
#import "EulaViewController.h"
#import "OrientationViewController.h"
#import "FTAppSettings.h"
#import "FTDatabase.h"
#import "FTSalesForce.h"
#import "FitnessIntroViewController.h"
#import "GAI.h"
#import "GAIDictionaryBuilder.h"


static NSArray *months;

static NSString* dateFormatForISO = @"yyyy-MM-dd";
static NSString* dateTimeFormatForISO = @"yyyy-MM-dd HH:mm:ss";
static NSString* dateTimeFormatForISOGMT = @"yyyy-MM-dd HH:mm:ss.SSS'Z'";
static NSString* dateFormatForDay = @"EEE, MM/dd/yy";
static NSString* dateFormatForWeek = @"MM/dd/yy";
static NSString* dayFormat = @"EEE,dd";

static const unsigned componentFlags = (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit);



@implementation UCFSUtil

+ (BOOL)deviceSystemIOS7 {
    return ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7);
}

+ (BOOL)deviceIs3inch  {
    return ([UIScreen mainScreen].bounds.size.height<=480);
}

+ (BOOL)deviceIsRetina {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        return YES;
    } else {
        return NO;
    }
}


+ (float) bottomPositionWithViewHeight:(float)height {
    float y = [UIScreen mainScreen].bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - height;
    if ([self deviceSystemIOS7]) y = y-44;
    return y;
}

+ (float)contentAreaHeight {
    float y = [UIScreen mainScreen].bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
    y = y -44; //navigation bar height
    //if ([self deviceSystemIOS7]) y = y-44;
    return y;
}

+ (float)fullContentAreaHeight {
    return [UIScreen mainScreen].bounds.size.height - [UIApplication sharedApplication].statusBarFrame.size.height;
}


+ (void)label:(UILabel*)label setText:(NSString*)text andCenterInRect:(CGRect)rect withFontName:(NSString*)fontName withMinFontSize:(float)minFontSize {
    label.text = text;//[NSString stringWithFormat:@"%d", indicatorNumber];
    
    CGFloat pointSize = 0.0f;
    CGRect frame = label.frame;
    frame.size = [label.text sizeWithFont:label.font
                              minFontSize:minFontSize
                           actualFontSize:&pointSize
                                 forWidth:rect.size.width
                            lineBreakMode:label.lineBreakMode];
    
    UIFont *actualFont = [UIFont fontWithName:fontName size:pointSize];
    CGSize sizeWithCorrectHeight = [label.text sizeWithFont:actualFont];
    frame.size.height = sizeWithCorrectHeight.height;
    label.frame = frame;
    label.font = actualFont;

   
   label.center = CGPointMake(rect.origin.x+(rect.size.width / 2.0f), rect.origin.y+(rect.size.height/ 2.0f) );
}


+ (UIViewController*)getViewControllerWithSection:(SectionType)sectionType withAction:(FTNotificationAction*)action {
    
    UIViewController* viewController = nil;
    
    switch(sectionType) {
        case SECTION_FITNESS:
            viewController = [[FitnessHomeViewController alloc] initWithAction:action];
            break;
        case SECTION_HEALTH:
            viewController = [[HealthHomeViewController alloc] initWithAction:action];
            break;
        case SECTION_MOOD:
            viewController = [[MoodHomeViewController alloc] initWithAction:action];
            break;
    }
    
    return viewController;
}

+ (void) initNavigationBar: (UINavigationBar*)navBar
                      item: (UINavigationItem*)navigationItem
                     title:(NSString*)title
               bkgFileName:(NSString*)bkgFileName
                 textColor:(UIColor*)textColor
            isBackVisibile:(BOOL)isBackVisibile {
    
    navBar.hidden = NO;
    navBar.barStyle = UIBarStyleBlackTranslucent;
    navigationItem.title = title;
    NSDictionary *dictionary = nil;
    
    if ([UCFSUtil deviceSystemIOS7]) {
        dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                        [UIColor clearColor],
                        NSBackgroundColorAttributeName,
                        textColor,
                        NSForegroundColorAttributeName,
                        [UIFont fontWithName:@"SourceSansPro-Semibold" size:20.0],
                        NSFontAttributeName,
                        nil];
        
        if (textColor == [UIColor whiteColor]) {
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }
        else
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        
     }
    else {
        dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                      textColor,
                      UITextAttributeTextColor,
                      [UIColor blackColor],
                      UITextAttributeTextShadowColor,
                      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
                      UITextAttributeTextShadowOffset,
                      [UIFont fontWithName:@"SourceSansPro-Semibold" size:20.0],
                      UITextAttributeFont,
                      nil];
    }
    navBar.titleTextAttributes = dictionary;
    
    //    CGRect frame = [self.navigationController.navigationBar frame];
    //    frame.size.height = 38.0f;
    //    [self.navigationController.navigationBar setFrame:frame];
    if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] ) {
        UIImage *image = [UIImage imageNamed:bkgFileName];
        [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
    
    if (isBackVisibile==NO) {
        navigationItem.hidesBackButton = YES;
        navigationItem.leftBarButtonItem=nil;
    }
    
    //[navBar setBounds:CGRectMake(0, 0, 320, 39)];
    
    
}

+ (UIBarButtonItem*) getNavigationBarMenuButton:(NSString*)label withTarget:(id)target action:(SEL)aSelector {
    
    int offset_x = 20;
    int offset_y = 20;
    if ([UCFSUtil deviceSystemIOS7]) {
        offset_x = 0;
        offset_y = 0;
    }
    
    
    UIImage *buttonImage = [UIImage imageNamed:@"lateral_menu.png"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0, buttonImage.size.width, buttonImage.size.height)];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:target action:aSelector forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0,offset_y,buttonImage.size.width+offset_x,buttonImage.size.height)];
    [button setIsAccessibilityElement:YES];
    [button setAccessibilityLabel:@"menu button"];
    [button setAccessibilityHint:@"Tap to open the lateral menu"];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButton;
    
}

+ (UIBarButtonItem*) getNavigationBarMenuDarkButton:(NSString*)label withTarget:(id)target action:(SEL)aSelector {
    
    int offset_x = 20;
    int offset_y = 20;
    if ([UCFSUtil deviceSystemIOS7]) {
        offset_x = 0;
        offset_y = 0;
    }
    
    
    UIImage *buttonImage = [UIImage imageNamed:@"menu_black.png"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0, buttonImage.size.width, buttonImage.size.height)];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:target action:aSelector forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0,offset_y,buttonImage.size.width+offset_x,buttonImage.size.height)];
    [button setIsAccessibilityElement:YES];
    [button setAccessibilityLabel:@"menu button"];
    [button setAccessibilityHint:@"Tap to open the lateral menu"];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButton;
    
}

+ (UIBarButtonItem*) getNavigationBarMenuGrayButton:(NSString*)label withTarget:(id)target action:(SEL)aSelector {
    
    int offset_x = 20;
    int offset_y = 20;
    if ([UCFSUtil deviceSystemIOS7]) {
        offset_x = 0;
        offset_y = 0;
    }
    
    
    UIImage *buttonImage = [UIImage imageNamed:@"lateral_menu.png"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0, buttonImage.size.width, buttonImage.size.height)];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:target action:aSelector forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0,offset_y,buttonImage.size.width+offset_x,buttonImage.size.height)];
    [button setIsAccessibilityElement:YES];
    [button setAccessibilityLabel:@"menu button"];
    [button setAccessibilityHint:@"Tap to open the lateral menu"];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return barButton;
    
}


+ (UIBarButtonItem*) getNavigationBarAddButton:(NSString*)label withTarget:(id)target action:(SEL)aSelector {
    
    int offset_x = 20;
    int offset_y = 00;
    if ([UCFSUtil deviceSystemIOS7]) {
        offset_x = 0;
        offset_y = 0;
    }
    
    UIImage *buttonImage = [UIImage imageNamed:@"plus_icon"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0, buttonImage.size.width, buttonImage.size.height)];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:target action:aSelector forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0,offset_y,buttonImage.size.width+offset_x,buttonImage.size.height)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButton;
    
}


+ (UIBarButtonItem*) getNavigationBarActionButtonWithTarget:(id)target action:(SEL)aSelector {
    
    int offset_x = 20;
    int offset_y = 20;
    if ([UCFSUtil deviceSystemIOS7]) {
        offset_x = 0;
        offset_y = 0;
    }
    
    UIImage *buttonImage = [UIImage imageNamed:@"btn_gear.png"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0, buttonImage.size.width, buttonImage.size.height)];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:target action:aSelector forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0,offset_y,buttonImage.size.width+offset_x,buttonImage.size.height)];
    [button setIsAccessibilityElement:YES];
    [button setAccessibilityLabel:@"setting button"];
    [button setAccessibilityHint:@"Tap to open the setting"];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButton;
    
}

+ (UIBarButtonItem*) getNavigationBarGoalReachedButtonWithTarget:(id)target action:(SEL)aSelector {
    
    int offset_x = 20;
    int offset_y = 20;
    if ([UCFSUtil deviceSystemIOS7]) {
        offset_x = 0;
        offset_y = 0;
    }
    
    UIImage *buttonImage = [UIImage imageNamed:@"btn_goalreached.png"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0, buttonImage.size.width, buttonImage.size.height)];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:target action:aSelector forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0,offset_y,buttonImage.size.width+offset_x,buttonImage.size.height)];
    [button setIsAccessibilityElement:YES];
    [button setAccessibilityLabel:@"geal reached button"];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButton;
    
}

+ (UIBarButtonItem*) getNavigationBarReminderButtonWithTarget:(id)target action:(SEL)aSelector asDark:(BOOL)isDark {
    
    int offset_x = 20;
    int offset_y = 20;
    if ([UCFSUtil deviceSystemIOS7]) {
        offset_x = 0;
        offset_y = 0;
    }

    UIImage *buttonImage;
    if (isDark)
        buttonImage = [UIImage imageNamed:@"remainder_black_act"];
    else
        buttonImage = [UIImage imageNamed:@"remainder_act"];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0, buttonImage.size.width, buttonImage.size.height)];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:target action:aSelector forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0,offset_y,buttonImage.size.width+offset_x,buttonImage.size.height)];
    [button setAccessibilityLabel:@"Reminder"];
    [button setAccessibilityHint:@"Tap to change the reminder"];
    [button setAccessibilityValue:@"A reminder is setted"];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButton;
    
}

+ (UIBarButtonItem*) getNavigationBarReminderOffButtonWithTarget:(id)target action:(SEL)aSelector asDark:(BOOL)isDark {
    
    int offset_x = 20;
    int offset_y = 20;
    if ([UCFSUtil deviceSystemIOS7]) {
        offset_x = 0;
        offset_y = 0;
    }
    
    UIImage *buttonImage;
    if (isDark)
        buttonImage = [UIImage imageNamed:@"reminder dark"];
    else
        buttonImage = [UIImage imageNamed:@"health_reminder_off"];
    
    //UIImage *buttonImage = [UIImage imageNamed:@"remainder_black_act.png"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0, buttonImage.size.width, buttonImage.size.height)];
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:target action:aSelector forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0,offset_y,buttonImage.size.width+offset_x,buttonImage.size.height)];
    [button setAccessibilityLabel:@"Reminder"];
    [button setAccessibilityHint:@"Tap to set a reminder"];
    [button setAccessibilityValue:@"A reminder is not configured"];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButton;
    
}

+ (UIBarButtonItem*) getNavigationBarCancelButtonWithTarget:(id)target action:(SEL)aSelector withTextColor:(UIColor*)textColor {
    int offset_x = 20;
    int offset_y = 20;
    if ([UCFSUtil deviceSystemIOS7]) {
        offset_x = 0;
        offset_y = 0;
    }
    
    
    UIImage *buttonImage = [UIImage imageNamed:@"btn_top.png"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0, buttonImage.size.width, buttonImage.size.height)];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:target action:aSelector forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(0,offset_y,buttonImage.size.width+offset_x,buttonImage.size.height)];
    [button setTitle:@"Back" forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    button.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18.0];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButton;
}

+ (UIBarButtonItem*) getNavigationBarCancelButtonWithTarget:(id)target action:(SEL)aSelector withSection:(Class<FTSection>)section {
    
    return [UCFSUtil getNavigationBarCancelButtonWithTarget:target action:aSelector withTextColor:[section navBarTextColor:0]];
}



+ (UIBarButtonItem*) getNavigationBarSaveButtonWithTarget:(id)target action:(SEL)aSelector withSection:(Class<FTSection>)section {
    
    int offset_x = 20;
    int offset_y = 20;
    if ([UCFSUtil deviceSystemIOS7]) {
        offset_x = 0;
        offset_y = 0;
    }
    
    UIImage *buttonImage = [UIImage imageNamed:@"btn_top.png"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0, buttonImage.size.width, buttonImage.size.height)];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:target action:aSelector forControlEvents:UIControlEventTouchUpInside];
    //[button setFrame:CGRectMake(0,offset_y,buttonImage.size.width+offset_x,buttonImage.size.height)];
    [button setTitle:@"Save" forState:UIControlStateNormal];
    [button setTitleColor:[section navBarTextColor:0] forState:UIControlStateNormal];
    //[button setTitleEdgeInsets:UIEdgeInsetsMake(-20.0, 10.0, 0.0, 0.0)];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    button.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18.0];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButton;
    
}

+ (UIBarButtonItem*) getNavigationBarDoneButtonWithTarget:(id)target action:(SEL)aSelector withSection:(Class<FTSection>)section {
    
    int offset_x = 20;
    int offset_y = 20;
    if ([UCFSUtil deviceSystemIOS7]) {
        offset_x = 0;
        offset_y = 0;
    }
    
    UIImage *buttonImage = [UIImage imageNamed:@"btn_top.png"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0, buttonImage.size.width, buttonImage.size.height)];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:target action:aSelector forControlEvents:UIControlEventTouchUpInside];
    //[button setFrame:CGRectMake(0,offset_y,buttonImage.size.width+offset_x,buttonImage.size.height)];
    [button setTitle:@"Done" forState:UIControlStateNormal];
    [button setTitleColor:[section navBarTextColor:0] forState:UIControlStateNormal];
    //[button setTitleEdgeInsets:UIEdgeInsetsMake(-20.0, 10.0, 0.0, 0.0)];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    button.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18.0];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButton;
    
}

+ (UIBarButtonItem*) getNavigationBarNextButtonWithTarget:(id)target action:(SEL)aSelector withSection:(Class<FTSection>)section {
    
    int offset_x = 20;
    int offset_y = 20;
    if ([UCFSUtil deviceSystemIOS7]) {
        offset_x = 0;
        offset_y = 0;
    }
    
    UIImage *buttonImage = [UIImage imageNamed:@"btn_top.png"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0, buttonImage.size.width, buttonImage.size.height)];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:target action:aSelector forControlEvents:UIControlEventTouchUpInside];
    //[button setFrame:CGRectMake(0,offset_y,buttonImage.size.width+offset_x,buttonImage.size.height)];
    [button setTitle:@"Next" forState:UIControlStateNormal];
    [button setTitleColor:[section navBarTextColor:0] forState:UIControlStateNormal];
    //[button setTitleEdgeInsets:UIEdgeInsetsMake(-20.0, 10.0, 0.0, 0.0)];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    button.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18.0];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButton;
    
}

+ (UIBarButtonItem*) getNavigationBarNextButtonWithTarget:(id)target action:(SEL)aSelector withTextColor:(UIColor*)textColor {
    
    int offset_x = 20;
    int offset_y = 20;
    if ([UCFSUtil deviceSystemIOS7]) {
        offset_x = 0;
        offset_y = 0;
    }
    
    UIImage *buttonImage = [UIImage imageNamed:@"btn_top.png"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0, buttonImage.size.width, buttonImage.size.height)];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:target action:aSelector forControlEvents:UIControlEventTouchUpInside];
    //[button setFrame:CGRectMake(0,offset_y,buttonImage.size.width+offset_x,buttonImage.size.height)];
    [button setTitle:@"Next" forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    //[button setTitleEdgeInsets:UIEdgeInsetsMake(-20.0, 10.0, 0.0, 0.0)];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    button.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18.0];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButton;
    
}

+ (UIBarButtonItem*) getNavigationBarGoButtonWithTarget:(id)target action:(SEL)aSelector withTextColor:(UIColor*)textColor {
    
    int offset_x = 20;
    int offset_y = 20;
    if ([UCFSUtil deviceSystemIOS7]) {
        offset_x = 0;
        offset_y = 0;
    }
    
    UIImage *buttonImage = [UIImage imageNamed:@"btn_top.png"];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0,0, buttonImage.size.width, buttonImage.size.height)];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button addTarget:target action:aSelector forControlEvents:UIControlEventTouchUpInside];
    //[button setFrame:CGRectMake(0,offset_y,buttonImage.size.width+offset_x,buttonImage.size.height)];
    [button setTitle:@"GO" forState:UIControlStateNormal];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    //[button setTitleEdgeInsets:UIEdgeInsetsMake(-20.0, 10.0, 0.0, 0.0)];
    [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    button.titleLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18.0];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButton;
    
}

+ (TBCircularSlider*) createCircularSliderWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withTarget:(id)target action:(SEL)aSelector asDouble:(BOOL)isDouble {
    //Create the Circular Slider
    int goal = [section getCurrentGoal];
    TBCircularSlider *slider = nil;
    slider = [[TBCircularSlider alloc]initWithFrame:frame withRadius:104 withSize:30];
    //slider.wheelBackgroundColor = [section lightColor:goal];
    slider.wheelBackgroundColor = [UIColor colorWithRed:231.0/255.0 green:231.0/255.0 blue:231.0/255.0 alpha:1];
    slider.guideSize = 3;
    slider.guideBackgroundColor = [section mainColor:goal];
    slider.guideForegroundColor = [section mainColor:goal];
    slider.handleSize = 60;
    slider.handleInternalSize = 50;
    slider.handleColor = [UIColor blackColor];
    slider.handleInternalColor = [UIColor whiteColor];
    //slider.handleColor = [section mainColor:goal];
    //slider.handleInternalColor = [section darkColor:goal];

    
    //Define Target-Action behaviour
    [slider addTarget:target action:aSelector forControlEvents:UIControlEventValueChanged];
    
    return slider;
}


+ (FTCircularTimerSlider*) createCircularTimeSliderWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withTarget:(id)target action:(SEL)aSelector {
    //Create the Circular Slider
    int goal = [section getCurrentGoal];

    FTCircularTimerSlider *slider = [[FTCircularTimerSlider alloc]initWithFrame:frame withRadius:125 withSize:40];
    slider.wheelBackgroundColor = [section lightColor:goal];
    slider.handleColor = [section mainColor:goal];
    slider.handleInternalColor = [section darkColor:goal];
    slider.hourBarForegroundColor = [section mainColor:goal];
    slider.guideBackgroundColor = [UIColor colorWithRed:208.0/255.0 green:208.0/255.0 blue:208.0/255.0 alpha:0.6];
    slider.guideForegroundColor = [UIColor whiteColor];
    slider.guideSize = 7;
    slider.hourBarRadius = 80;
    slider.hourBarSize = 10;
    slider.hourBarBackgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
    slider.handleSize = 40;
    slider.handleInternalSize = 27;
    
    
    //Define Target-Action behaviour
    [slider addTarget:target action:aSelector forControlEvents:UIControlEventValueChanged];
    
    return slider;
}


+ (FTFrequencySlider*) createFrequencySliderWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withPositions:(NSArray*)positions  {
    //Create the Slider
    FTFrequencySlider *slider = [[FTFrequencySlider alloc]initWithFrame:frame withPositions:positions];
    slider.handleColor = [section mainColor:0];
    slider.handleInternalColor = [UIColor whiteColor];
    //slider.handleColor = [section mainColor:goal];
    //slider.handleInternalColor = [section darkColor:-1];
    slider.handleSize = 45;
    slider.handleInternalSize = 38;
    
    return slider;
}


+ (void)initSegmentedControl:(UISegmentedControl*)segmented withSelectedColor:(UIColor*)selectedColor {
    
    [segmented setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [UIFont fontWithName:@"SourceSansPro-Regular" size:16.0], UITextAttributeFont,
                                                             [UIColor lightGrayColor], UITextAttributeTextColor,
                                                             [UIColor whiteColor], UITextAttributeTextShadowColor,
                                                             [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)], UITextAttributeTextShadowOffset,
                                                             nil]
                                                   forState:UIControlStateNormal];
    
    [segmented setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [UIFont fontWithName:@"SourceSansPro-Regular" size:16.0], UITextAttributeFont,
                                                             selectedColor, UITextAttributeTextColor,
                                                             [UIColor whiteColor], UITextAttributeTextShadowColor,
                                                             [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)],
                                                             UITextAttributeTextShadowOffset,
                                                             nil]
                                                   forState:UIControlStateHighlighted];
    [segmented setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                             [UIFont fontWithName:@"SourceSansPro-Regular" size:16.0], UITextAttributeFont,
                                                             selectedColor, UITextAttributeTextColor,
                                                             [UIColor whiteColor], UITextAttributeTextShadowColor,
                                                             [NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)],
                                                             UITextAttributeTextShadowOffset,
                                                             nil]
                                                   forState:UIControlStateSelected];
    
    
    CGRect frame= segmented.frame;
    [segmented setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 36)];
    
    // Set divider images
    [segmented setDividerImage:[UIImage imageNamed:@"segmented_split.png"]
           forLeftSegmentState:UIControlStateNormal
             rightSegmentState:UIControlStateNormal
                    barMetrics:UIBarMetricsDefault];
    [segmented setDividerImage:[UIImage imageNamed:@"segmented_split.png"]
           forLeftSegmentState:UIControlStateSelected
             rightSegmentState:UIControlStateNormal
                    barMetrics:UIBarMetricsDefault];
    [segmented setDividerImage:[UIImage imageNamed:@"segmented_split.png"]
           forLeftSegmentState:UIControlStateNormal
             rightSegmentState:UIControlStateSelected
                    barMetrics:UIBarMetricsDefault];
    
    // Set background images
    UIImage *normalBackgroundImage = [UIImage imageNamed:@"segmented.png"];
    [segmented setBackgroundImage:normalBackgroundImage
                         forState:UIControlStateNormal
                       barMetrics:UIBarMetricsDefault];
    UIImage *selectedBackgroundImage = [UIImage imageNamed:@"segmented.png"];
    [segmented setBackgroundImage:selectedBackgroundImage
                         forState:UIControlStateSelected
                       barMetrics:UIBarMetricsDefault];
}


+ (AFPickerView*)initPickerWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withDatasource:(id<AFPickerViewDataSource>)dataSource withDelegate:(id<AFPickerViewDelegate>)delegate withFont:(UIFont*)font  withRowHeight:(float)rowHeight withIndent:(float)rowIndent withAligment:(int)alignment withTag:(int)tag {
    

    AFPickerView *picker = [[AFPickerView alloc] initWithFrame:frame
                                                 withRowHeight:rowHeight
                                                withBackground:nil
                                                    withShadow:nil];
    picker.dataSource = dataSource;
    picker.delegate = delegate;
    picker.textColor = [UIColor blackColor];
    if ([section sectionType]==SECTION_MOOD)
        picker.selectedtextColor = [UIColor colorWithRed:72.0/255.0 green:72.0/255.0 blue:72.0/255.0 alpha:1.0];
    else
        picker.selectedtextColor = [UIColor whiteColor];
    picker.rowFont = font;
    picker.rowIndent = rowIndent;
    picker.alignment = alignment;
    picker.tag = tag;
    
    return picker;
}




+ (UIView*)loadingView {
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.9;
    return view;
}


+ (void) printFonts {
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
}


+ (NSString*)stringWithValueAsTime:(float)value {
    int minutes = trunc(value / 60);
    int seconds = value - (minutes*60);
    if (seconds<10)
        return [NSString stringWithFormat:@"%i:0%i", (int)minutes, (int)seconds];
    else
        return [NSString stringWithFormat:@"%i:%i", (int)minutes, (int)seconds];
    
}

+ (NSString*)stringWithValue:(float)value formatAsFloat:(BOOL)asFloat formatAsCompact:(BOOL)asCompact {
    
    if (asCompact && value>=1000) {
        float compactedValue = value/1000;
        return [NSString stringWithFormat:@"%.01fK", compactedValue];
    }
    else {
        if (asFloat) {
            return [NSString stringWithFormat:@"%.01f", value];
        }
        else {
            return [NSString stringWithFormat:@"%d", (int)(round(value))];
        }
    }
}

+ (NSString*)formatMonthWithIndex:(int)month {
    if (months==nil) {
        months = [[NSArray alloc] initWithObjects:
                  @"JAN",
                  @"FEB",
                  @"MAR",
                  @"APR",
                  @"MAY",
                  @"JUN",
                  @"JUL",
                  @"AUG",
                  @"SEP",
                  @"OCT",
                  @"NOV",
                  @"DEC",
                  nil
                  ];
    }
    
    return [months objectAtIndex:month];
}




+ (NSString*)formatLogDate:(FTLogGroupedData*)logData {
    NSString* result;

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    switch (logData.dateType) {
        case 0: { //day
            [dateFormatter setDateFormat:dateFormatForISO];
            NSDate *date = [dateFormatter dateFromString:logData.dateValue];
            [dateFormatter setDateFormat:dateFormatForDay];
            result = [dateFormatter stringFromDate:date];
            break;
        }
        case 1: { //week
            /*
            NSArray* dateArray = [dateValue componentsSeparatedByString: @"-"];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *comps = [[NSDateComponents alloc] init];
            [comps setWeekday:1];
            [comps setYearForWeekOfYear: [[dateArray objectAtIndex:0] intValue]];
            [comps setWeekOfYear: ([[dateArray objectAtIndex:1] intValue]+1)];
            NSDate *dateFirst = [calendar dateFromComponents:comps];
            [comps setWeekday:7];
            NSDate *dateLast = [calendar dateFromComponents:comps];
            [dateFormatter setDateFormat:dateFormatForDay];
             */
            [dateFormatter setDateFormat:dateFormatForISO];
            NSDate *weekStartDate = [dateFormatter dateFromString:logData.weekStartDate];
            NSDate *weekEndDate = [dateFormatter dateFromString:logData.weekEndDate];
            [dateFormatter setDateFormat:dateFormatForWeek];
            result = [dateFormatter stringFromDate:weekStartDate];
            result = [result stringByAppendingString:@" to " ];
            result = [result stringByAppendingString:[dateFormatter stringFromDate:weekEndDate] ];
            break;
        }
        case 2: { //month
            NSArray* dateArray = [logData.dateValue componentsSeparatedByString: @"-"];
            int monthIndex = ([[dateArray objectAtIndex:1] intValue]-1);
            result = [self formatMonthWithIndex:monthIndex];
            result = [result stringByAppendingString:@" "];
            result = [result stringByAppendingString:[dateArray objectAtIndex:0]];
        }
            break;
    }
    
    return result;
}

+ (NSDateComponents*)dateComp {
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:today];
}

+ (NSDateComponents*)dateTimeComp {
    NSDate *today = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour| NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:today];
}

+ (int)hour24From12:(int)hour withType:(int)amPm {
    if (amPm==0) { //am
        if (hour==12)
            return 0;
        else
            return hour;
    }
    else { //pm
        if (hour==12)
            return 12;
        else
            return 12+hour;
    }
}

+ (NSString*)formatDay:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dayFormat];
    return [dateFormatter stringFromDate:date];
    
}

+ (NSString*)formatDateTime:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateTimeFormatForISO];
    return [dateFormatter stringFromDate:date];
}

+ (NSString*)formatDateTimeGmt:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateTimeFormatForISOGMT];
    return [dateFormatter stringFromDate:date];
}

+ (NSString*)formatDate:(NSDate*)date withFormat:(NSString*)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}



+ (int)numMonthWithYear:(int)year {
    NSInteger currentYear = [[self dateComp] year];
    if (currentYear!=year) {
        return 12;
    }
    else {
        return [[self dateComp] month];
    }
}

+ (int)numDaysWithMonth:(int)month withYear:(int)year {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    [comps setMonth:month];
    [comps setYear:year];
    NSDate *date = [calendar dateFromComponents:comps];
    NSRange days = [calendar rangeOfUnit:NSDayCalendarUnit
                                  inUnit:NSMonthCalendarUnit
                                 forDate:date];
    
    return days.length;
}

+ (int)numDaysWithinCurrentMonth:(int)month withinCurrentYear:(int)year {
    
    NSInteger currentYear = [[self dateComp] year];
    NSInteger currentMonth = [[self dateComp] month];
    
    if (year!=currentYear || currentMonth!=month) {
        return [self numDaysWithMonth:month withYear:year];
    }
    else {
        return [[self dateComp] day];
    }
}

+ (NSDate*)getDate:(NSDate*)date addDays:(int)days {
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = days;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dayComponent toDate:date options:0];
   
}

+ (NSDate*)setTimeWithDate:(NSDate*)date withHours:(int)hour withMinutes:(int)minutes withSeconds:(int)seconds {
    if (date!=nil) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
        NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
        comps.hour   = hour;
        comps.minute = minutes;
        comps.second = seconds;
        return [calendar dateFromComponents:comps];
    }
    return nil;
}

+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
    	return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
    	return NO;
    
    return YES;
}

+ (BOOL)date:(NSDate*)date isEqualToDateIgnoringTime:(NSDate*)aDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components1 = [calendar components:componentFlags fromDate:date];
	NSDateComponents *components2 = [calendar components:componentFlags fromDate:aDate];
	return ((components1.year == components2.year) &&
			(components1.month == components2.month) &&
			(components1.day == components2.day));
}

+ (NSDate*)dateYesterday
{
	return [self getDate:[NSDate date] addDays:-1];
}

+ (BOOL)isToday:(NSDate*)date
{
	return [self date:date isEqualToDateIgnoringTime:[NSDate date]];
}

+ (BOOL)isYesterday:(NSDate*)date
{
	return [self date:date isEqualToDateIgnoringTime:[UCFSUtil dateYesterday]];
}

+ (BOOL)date:(NSDate*)date isSameDay:(NSDate*)otherDate
{
	return [self date:date isEqualToDateIgnoringTime:otherDate];
}

+ (NSInteger)daysBetween:(NSDate *)dt1 and:(NSDate *)dt2 {
    NSUInteger unitFlags = NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    //normalize
    NSDate* startDate = [UCFSUtil setTimeWithDate:dt1 withHours:0 withMinutes:0 withSeconds:0];
    NSDate* endDate = [UCFSUtil setTimeWithDate:dt2 withHours:23 withMinutes:59 withSeconds:59];

    NSDateComponents *components = [calendar components:unitFlags fromDate:startDate toDate:endDate options:0];
    NSInteger daysBetween = abs([components day]);
    return daysBetween+1;
}

+ (NSString*) datetimeGMT:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'.000Z'";
    
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    return [dateFormatter stringFromDate:date];
    
}


+ (float)normalizedValue:(float)value withDateType:(int)dateType {
    switch(dateType) {
        case 0:
            return value / 7;
            break;
        case 1:
            return value;
            break;
        case 2:
            return value * 4;
            break;
    }
    return  0;
}

+ (NSMutableArray*)noteHeadersFromJson:(NSString*)filename {
    NSMutableArray* result = [NSMutableArray array];
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
    NSData* fileData = [[NSFileManager defaultManager] contentsAtPath:filePath];
    NSError* e = nil;
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableContainers error:&e];
    
    if (jsonArray) {
        for (NSDictionary* sectionJson in jsonArray) {
            int uniqueid = [[sectionJson objectForKey:@"uniqueId"] integerValue];
            NSString* label = [sectionJson objectForKey:@"label"];
            FTNoteHeader* noteHeader = [[FTNoteHeader alloc] initWithId:uniqueid withLabel:label];
            NSArray* notes = (NSArray*)[sectionJson objectForKey:@"notes"];
            if (notes!=nil && [notes count]>0) {
                for (NSDictionary* noteJson in notes) {
                    FTNote* note = [[FTNote alloc] init];
                    note.uniqueId = [[noteJson objectForKey:@"uniqueId"] integerValue];
                    note.note = [noteJson objectForKey:@"note"];
                    note.noteAcc = [noteJson objectForKey:@"noteAcc"];
                    note.linkAcc = [noteJson objectForKey:@"linkAcc"];
                    [noteHeader.notes addObject:note];
                }
            }
            [result addObject:noteHeader];
        }
    }
    else
        NSLog(@"Error parsing JSON: %@", e);
    
    
    return result;
    
}

+ (NSMutableArray*)notificationsFromJson:(NSString*)filename {
    NSMutableArray* result = [NSMutableArray array];
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
    NSData* fileData = [[NSFileManager defaultManager] contentsAtPath:filePath];
    NSError* e = nil;
    NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableContainers error:&e];
    
    if (jsonArray) {
        for (NSDictionary* sectionJson in jsonArray) {
            FTNotification* notification = [[FTNotification alloc] init];
            notification.uniqueid = [[sectionJson objectForKey:@"uniqueid"] integerValue];
            notification.index = [[sectionJson objectForKey:@"index"] integerValue];
            notification.section = [[sectionJson objectForKey:@"section"] integerValue];
            notification.goal = [[sectionJson objectForKey:@"goal"] integerValue];
            notification.message = [sectionJson objectForKey:@"message"];
            notification.action = [[FTNotificationAction alloc] init];
            notification.action.actionMessage = [sectionJson objectForKey:@"actionMessage"];
            notification.action.actionSection = [[sectionJson objectForKey:@"actionSection"] integerValue];
            notification.action.actionGoal = notification.goal;
            notification.action.actionScreen = [[sectionJson objectForKey:@"actionScreen"] integerValue];
            notification.action.actionItem = [[sectionJson objectForKey:@"actionItem"] integerValue];
            
            notification.datetype = 0;
            if ([sectionJson objectForKey:@"datetype"]!=nil)
                notification.datetype = [[sectionJson objectForKey:@"datetype"] integerValue];

            [result addObject:notification];
        }
    }
    else
        NSLog(@"Error parsing JSON: %@", e);
    
    
    return result;
    
}

+ (FTNotification*)nextLocalNotificationWithSection:(int)section withGoal:(int)goal withDateType:(int)dateType withLast:(int)lastIndex {
    FTNotification* notification = nil;
    switch (section) {
        case SECTION_FITNESS:
            notification = [FitnessSection nextLocalNotificationWithGoal:goal withDateType:dateType withLast:lastIndex];
            break;
        case SECTION_HEALTH:
            notification = [HealthSection nextLocalNotificationWithGoal:goal withDateType:dateType withLast:lastIndex];
            break;
        case SECTION_MOOD:
            notification = [MoodSection nextLocalNotificationWithGoal:goal withDateType:dateType withLast:lastIndex];
            break;
    }
    return notification;
}

+ (FTReminderData*)remiderWithSection:(int)section withGoal:(int)goal {
    FTReminderData* reminder = nil;
    switch (section) {
        case SECTION_FITNESS:
            reminder = [FitnessSection loadReminderWithGoal:goal];
            break;
        case SECTION_HEALTH:
            reminder = [HealthSection loadReminderWithGoal:goal];
            break;
        case SECTION_MOOD:
            reminder = [MoodSection loadReminderWithGoal:goal];
            break;
    }
    
    return reminder;
}

+ (UIViewController*)getViewControllerAtStartWithNotification:(UILocalNotification*)locationNotification {
        UIViewController* viewController = nil;
        
        if ([FTAppSettings isEulaConfirmed]) {
            if ([FTAppSettings isStudyIdConfirmed]) {
                if ([FTAppSettings isOrientationConfirmed]) {
                    if (locationNotification!=nil) {
                        FTNotificationAction* action = [FTNotificationManager processNotification:locationNotification];
                        if (action!=nil) {
                            viewController = [UCFSUtil getViewControllerWithSection:action.actionSection withAction:action];
                        }
                        else {
                            viewController = [self getFitnessViewController];
                        }
                    }
                    else {
                        //fitness
                        viewController = [self getFitnessViewController];
                    }
                }
                else
                    viewController = [[OrientationViewController alloc] initWithNibName:@"OrientationView" bundle:nil];
            }
            else
                viewController = [[StudyIdViewController alloc] initWithNibName:@"StudyIdView" bundle:nil];
        }
        else
            viewController = [[EulaViewController alloc] initWithNibName:@"EulaView" bundle:nil];
        
        
        return viewController;
}

+ (UIViewController*)getFitnessViewController {
    UIViewController* viewController = nil;
    
    [FitnessSection loadGoals];
    FTGoalData* goalData = [FitnessSection goalDataWithType:0];
    if (goalData!=nil) {
        if ([FTAppSettings getStartNewWeek]) {
            viewController = [[FitnessIntroViewController alloc] initWithNibName:@"FitnessIntroView" bundle:nil asNewWeek:TRUE];
        }
        else {
            viewController = [UCFSUtil getViewControllerWithSection:SECTION_FITNESS withAction:nil];
        }
    }
    else
        viewController = [[FitnessIntroViewController alloc] initWithNibName:@"FitnessIntroView" bundle:nil];
    
    return viewController;

}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (float)calculateMinutesFromSteps:(float)steps {
    return steps * (150.0 / 30000.0);
}

+ (float)calculateStepsFromMinutes:(float)minutes {
    return minutes * (30000.0 / 150.0);
}

+ (float)calculteProgress:(NSMutableArray*)items {
    if (items!=nil) {
        float total = 0;
        for (int i=0; i<[items count]; i++) {
            FTLogData* logData = (FTLogData*)[items objectAtIndex:i];
            total += logData.logValue;
        }
        return total;
    }
    
    return 0;
}


+(BOOL)syncData {
    @try {
        int studyId = [FTAppSettings getStudyId];
        if (studyId>0) {
            FTDatabase *db = [FTDatabase getInstance];
            NSMutableArray* goals = [db selectAllGoalToSync];
            NSMutableArray* logs = [db selectAllLogToSync];
            FTSalesForce* sf = [FTSalesForce getInstance];
            
            
            NSLog(@"Checking user with studyId=%i ...", studyId);
            NSString* userId = [sf createIfNotExistsUser:studyId];
            if (userId!=nil) {
                NSLog(@"Checking goals...");
                if (goals!=nil && ([goals count]>0)) {
                    for (int i=0; i<[goals count]; i++) {
                        FTGoalData* goalData = (FTGoalData*)[goals objectAtIndex:i];
                        if ([sf insertGoal:goalData withUser:studyId]) {
                            goalData.uploadedToServer = 1;
                            [db updateGoal:goalData];
                        }
                    }
                }
                else
                    NSLog(@"No goals to sync");
                
                NSLog(@"Checking logs...");
                if (logs!=nil && ([logs count]>0)) {
                    for (int i=0; i<[logs count]; i++) {
                        FTLogData* logData = (FTLogData*)[logs objectAtIndex:i];
                        if ([sf insertLog:logData withUser:studyId]) {
                            logData.uploadedToServer = 1;
                            [db updateLog:logData];
                        }
                        
                    }
                }
                else
                    NSLog(@"No logs to sync");
                
                return true;
            }
            else
                return false;
        }
        else
            NSLog(@"STUDYID is 0, skipping sync... ");
    }
    @catch(NSException* nse) {
        NSLog(@"ERROR %@", [nse reason]);
        return false;
    }
    
    
}

+ (NSString*)sectionName:(SectionType)sectionType withGoal:(int)goalId {
    NSString* result = @"";
    switch (sectionType) {
        case SECTION_FITNESS:
            result = @"Fitness";
            if (goalId==0) result = @"Fitness Time";
            if (goalId==1) result = @"Fitness Steps";
            break;
        case SECTION_HEALTH:
            result = @"Health";
            if (goalId==0) result = @"Health Weight";
            if (goalId==1) result = @"Health HeartRate";
            if (goalId==2) result = @"Health Pressure";
            if (goalId==3) result = @"Health Glucose";
            if (goalId==4) result = @"Health Cholesterol";
            break;
        case SECTION_MOOD:
            result = @"Mood";
            break;
        case 4:
            result = @"Nutrition";
        break;
    }
    
    return result;
}

+ (void)trackGAEventWithCategory:(NSString*)category withAction:(NSString*)action withLabel:(NSString*)label withValue:(NSNumber*)value {
    // May return nil if a tracker has not already been initialized with a property
    // ID.
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    if (tracker!=nil) {
        NSString* catWithId = [NSString stringWithFormat:@"user_%i", [FTAppSettings getStudyId]];
        
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:catWithId     // Event category (required)
                                                              action:action  // Event action (required)
                                                               label:label          // Event label
                                                               value:value] build]];    // Event value
        
    }
    
}


+ (NSString *)htmlFromBodyString:(NSString *)htmlBodyString
                        textFont:(UIFont *)font
                       textColor:(UIColor *)textColor
{
    int numComponents = CGColorGetNumberOfComponents([textColor CGColor]);
    
    NSAssert(numComponents == 4 || numComponents == 2, @"Unsupported color format");
    
    // E.g. FF00A5
    NSString *colorHexString = nil;
    
    const CGFloat *components = CGColorGetComponents([textColor CGColor]);
    
    if (numComponents == 4)
    {
        unsigned int red = components[0] * 255;
        unsigned int green = components[1] * 255;
        unsigned int blue = components[2] * 255;
        colorHexString = [NSString stringWithFormat:@"%02X%02X%02X", red, green, blue];
    }
    else
    {
        unsigned int white = components[0] * 255;
        colorHexString = [NSString stringWithFormat:@"%02X%02X%02X", white, white, white];
    }
    
    NSString *HTML = [NSString stringWithFormat:@"<html>\n"
                      "<head>\n"
                      "<style type=\"text/css\">\n"
                      "body {font-family: \"%@\"; font-size: %@; color:#%@;}\n"
                      "</style>\n"
                      "</head>\n"
                      "<body>%@</body>\n"
                      "</html>",
                      font.fontName, @"18", colorHexString, htmlBodyString];
    
    return HTML;
}




@end
