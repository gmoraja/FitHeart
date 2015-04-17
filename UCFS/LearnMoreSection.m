//
//  LearnMoreSection.m
//  FitHeart
//
//  Created by Bitgears on 17/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "LearnMoreSection.h"

NSString    *const UCFS_LearnMoreView_NavBar_Title = @"LEARN MORE";
NSString    *const UCFS_LearnMoreView_NavBar_Bkg = @"support_navbar_bkg";


@implementation LearnMoreSection

+ (NSString*) title {
    return UCFS_LearnMoreView_NavBar_Title;
}

+ (UIColor*) mainColor {
    return [UIColor colorWithRed:0.0/255.0 green:108.0/255.0 blue:136.0/255.0 alpha:1.0];
}

+ (UIColor*) lightColor {
    return [UIColor colorWithRed:124.0/255.0 green:150.0/255.0 blue:149.0/255.0 alpha:1.0];
}

+ (UIColor*) darkColor {
    return [UIColor colorWithRed:124.0/255.0 green:150.0/255.0 blue:149.0/255.0 alpha:1.0];
}

+ (NSString*) navBarBkg {
    return UCFS_LearnMoreView_NavBar_Bkg;
}



+ (UIColor*) footerColor {
    return [UIColor colorWithRed:124.0/255.0 green:150.0/255.0 blue:149.0/255.0 alpha:1.0];
}

+ (UIColor*) navBarTextColor {
    return [UIColor colorWithRed:72.0/255.0 green:72.0/255.0 blue:72.0/255.0 alpha:1.0];
}


@end
