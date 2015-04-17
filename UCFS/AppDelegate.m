//
//  AppDelegate.m
//  UCFS
//
//  Created by Bitgears on 30/10/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "AppDelegate.h"
#import "EulaViewController.h"
#import "StudyIdViewController.h"
#import "OrientationViewController.h"
#import "MMDrawerController.h"
#import "LateralMenuViewController.h"
#import "FitnessHomeViewController.h"
#import "HealthHomeViewController.h"
#import "NutritionHomeViewController.h"
#import "MoodHomeViewController.h"
#import "FTDatabase.h"
#import "FTAppSettings.h"
#import "FTNotificationManager.h"
#import "FTNotificationAction.h"
#import "UCFSUtil.h"
#import "GAI.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


@interface AppDelegate() {
    UIViewController * leftSideNavController;
    UINavigationController *navigationController;
    NSDate* lastBackgroundEnterDate;
}
    @property (nonatomic,strong) MMDrawerController * drawerController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[UINavigationBar appearance]setShadowImage:[[UIImage alloc] init]];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [Fabric with:@[CrashlyticsKit]];
    
    //FIX iOS8
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    //check database
    FTDatabase *db = [FTDatabase getInstance];
    [db createDatabase];
    
    [self initGoogleAnalytics];
    
    // Handle launching from a notification
    UILocalNotification *locationNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (locationNotification) {
    }
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
    
    //select view to launch
    leftSideNavController = [[LateralMenuViewController alloc] init];
    UIViewController * centerViewController = [UCFSUtil getViewControllerAtStartWithNotification:locationNotification];
    navigationController = [[UINavigationController alloc] initWithRootViewController:centerViewController];
    navigationController.navigationBar.translucent = NO;
    
    self.drawerController = [[MMDrawerController alloc]
                             initWithCenterViewController:navigationController
                             leftDrawerViewController:leftSideNavController
                             rightDrawerViewController:nil];
    [self.drawerController setShouldStretchDrawer:NO];
    if (UIAccessibilityIsVoiceOverRunning()) {
        [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        [self.drawerController setCenterHiddenInteractionMode:MMDrawerOpenCenterInteractionModeNone];
    }
    else {
        [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        [self.drawerController setCenterHiddenInteractionMode:MMDrawerOpenCenterInteractionModeNone];
    }
        
    
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setMaximumLeftDrawerWidth:230.0];
    
    self.window.rootViewController = self.drawerController;
    //self.window.rootViewController = navigationController;

    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    lastBackgroundEnterDate = [NSDate date];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    if (lastBackgroundEnterDate!=nil) {
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:lastBackgroundEnterDate];
        float minutes = interval / 60;
        if (minutes>1) {
            UIViewController* viewController = [UCFSUtil getFitnessViewController];
            [navigationController pushViewController:viewController animated:NO];
            [self selectMenuItem:0];
        }
        else {
            
        }
    }
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self syncInBackground:nil];
}

- (IBAction)syncInBackground:(id)sender {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [UCFSUtil syncData];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
                                                        message:notification.alertBody
                                                       delegate:self cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    FTNotificationAction* action = [FTNotificationManager processNotification:notification];
    
    // Set icon badge number to zero
    application.applicationIconBadgeNumber = 0;
    
    if (action!=nil) {
        UIViewController* viewController = [UCFSUtil getViewControllerWithSection:action.actionSection withAction:action];
        [navigationController pushViewController:viewController animated:NO];
    }
    
}

-(void)selectMenuItem:(int)item {
    LateralMenuViewController* menuContr = (LateralMenuViewController*)leftSideNavController;
    [menuContr selectMenuItem:item];
}


-(void)initGoogleAnalytics {
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelError];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-57104912-1"];
}



@end
