//
//  AboutSection.m
//  FitHeart
//
//  Created by Bitgears on 16/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "AboutSection.h"

NSString    *const UCFS_AboutView_NavBar_Title = @"ABOUT";
NSString    *const UCFS_AboutView_NavBar_Bkg = @"support_navbar_bkg";


@implementation AboutSection

+ (NSString*) title {
    return UCFS_AboutView_NavBar_Title;
}

+ (UIColor*) mainColor {
    return [UIColor colorWithRed:0.0/255.0 green:108.0/255.0 blue:136.0/255.0 alpha:1.0];
}

+ (UIColor*) lightColor {
    return [UIColor colorWithRed:255.0/255.0 green:158.0/255.0 blue:132.0/255.0 alpha:1.0];
}

+ (UIColor*) darkColor {
    return [UIColor colorWithRed:255.0/255.0 green:158.0/255.0 blue:132.0/255.0 alpha:1.0];
}

+ (NSString*) navBarBkg {
    return UCFS_AboutView_NavBar_Bkg;
}

+ (UIColor*) navBarTextColor {
    return [UIColor colorWithRed:72.0/255.0 green:72.0/255.0 blue:72.0/255.0 alpha:1.0];
}


+ (UIColor*) footerColor {
    return [UIColor colorWithRed:255.0/255.0 green:158.0/255.0 blue:132.0/255.0 alpha:1.0];
}

@end
