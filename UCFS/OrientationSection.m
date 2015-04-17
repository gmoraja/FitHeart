//
//  OrientationSection.m
//  FitHeart
//
//  Created by Bitgears on 09/11/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "OrientationSection.h"
#import "FTSection.h"

NSString    *const UCFS_OrientationView_NavBar_Title = @"WELCOME !";
NSString    *const UCFS_OrientationView_NavBar_Bkg = @"orientation_navbar_bkg";

@implementation OrientationSection

+ (NSString*) title {
    return UCFS_OrientationView_NavBar_Title;
}

+ (UIColor*) mainColor {
    return [UIColor colorWithRed:246.0/255.0 green:143.0/255.0 blue:85.0/255.0 alpha:1.0];
}

+ (UIColor*) lightColor {
    return [UIColor colorWithRed:246.0/255.0 green:143.0/255.0 blue:85.0/255.0 alpha:1.0];
}

+ (UIColor*) darkColor {
    return [UIColor colorWithRed:246.0/255.0 green:143.0/255.0 blue:85.0/255.0 alpha:1.0];
}

+ (NSString*) navBarBkg {
    return UCFS_OrientationView_NavBar_Bkg;
}

+ (UIColor*) navBarTextColor {
    return [UIColor colorWithRed:72.0/255.0 green:72.0/255.0 blue:72.0/255.0 alpha:1.0];
}

+ (UIColor*) footerColor {
    return [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
}




@end
