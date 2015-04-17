//
//  SettingsSection.m
//  FitHeart
//
//  Created by Bitgears on 19/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "SettingsSection.h"

NSString    *const UCFS_SettingsView_NavBar_Title = @"SETTINGS";
NSString    *const UCFS_SettingsView_NavBar_Bkg = @"support_navbar_bkg";


@implementation SettingsSection

+ (NSString*) title {
    return UCFS_SettingsView_NavBar_Title;
}

+ (UIColor*) mainColor {
    return [UIColor colorWithRed:0.0/255.0 green:108.0/255.0 blue:136.0/255.0 alpha:1.0];
}


+ (UIColor*) lightColor {
    return [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0];
}

+ (UIColor*) darkColor {
    return [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0];
}

+ (NSString*) navBarBkg {
    return UCFS_SettingsView_NavBar_Bkg;
}

+ (UIColor*) navBarTextColor {
    return [UIColor colorWithRed:72.0/255.0 green:72.0/255.0 blue:72.0/255.0 alpha:1.0];
}

+ (UIColor*) footerColor {
    return [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
}


@end
