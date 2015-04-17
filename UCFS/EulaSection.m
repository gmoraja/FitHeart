//
//  EulaSection.m
//  UCFS
//
//  Created by Bitgears on 31/10/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "EulaSection.h"


NSString    *const UCFS_EulaView_NavBar_Title = @"LICENSE AGREEMENT";
NSString    *const UCFS_EulaView_NavBar_Bkg = @"eula_navbar_bkg";

@implementation EulaSection

+ (NSString*) title {
    return UCFS_EulaView_NavBar_Title;
}

+ (UIColor*) mainColor {
    return [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0];
}

+ (UIColor*) lightColor {
    return [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0];
}

+ (UIColor*) darkColor {
    return [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0];
}

+ (NSString*) navBarBkg {
    return UCFS_EulaView_NavBar_Bkg;
}

+ (UIColor*) footerColor {
    return [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
}




@end
