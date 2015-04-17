//
//  StudyIdSection.m
//  UCFS
//
//  Created by Bitgears on 31/10/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "StudyIdSection.h"
#import "FTSection.h"

NSString    *const UCFS_StudyIdView_NavBar_Title = @"STUDY ID";
NSString    *const UCFS_StudyIdView_NavBar_Bkg = @"studyid_navbar_bkg";
CGFloat      const UCFS_StudyIdView_Picker_Top = 160.0;
CGFloat      const UCFS_StudyIdView_Picker_Left = 115.0;
CGFloat      const UCFS_StudyIdView_Picker_Width = 39;
CGFloat      const UCFS_StudyIdView_Picker_Height = 197.0;

@implementation StudyIdSection

+ (NSString*) title {
    return UCFS_StudyIdView_NavBar_Title;
}

+ (UIColor*) mainColor {
    return [UIColor colorWithRed:189.0/255.0 green:179.0/255.0 blue:145.0/255.0 alpha:1.0];
}

+ (UIColor*) lightColor {
    return [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0];
}

+ (UIColor*) darkColor {
    return [UIColor colorWithRed:190.0/255.0 green:190.0/255.0 blue:190.0/255.0 alpha:1.0];
}

+ (NSString*) navBarBkg {
    return UCFS_StudyIdView_NavBar_Bkg;
}

+ (UIColor*) footerColor {
    return [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
}



@end
