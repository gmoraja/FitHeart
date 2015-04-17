//
//  AppDelegate.h
//  UCFS
//
//  Created by Bitgears on 30/10/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *rootController;

-(void)selectMenuItem:(int)item;

@end
