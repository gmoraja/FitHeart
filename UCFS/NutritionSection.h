//
//  NutritionSection.h
//  FitHeart
//
//  Created by Bitgears on 27/11/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTSection.h"

extern NSString     *const UCFS_NutritionView_NavBar_Title;
extern NSString     *const UCFS_NutritionGoalView_NavBar_Title;
extern NSString     *const UCFS_NutritionView_NavBar_Bkg;

enum {
    NUTRITION_GOAL_WEIGHT          = 0,
    NUTRITION_GOAL_CALORIES        = 1

}; typedef NSUInteger NutritionGoal;

@interface NutritionSection : NSObject <FTSection> {
    
}

+ (NSArray*)getMeals;

@end
