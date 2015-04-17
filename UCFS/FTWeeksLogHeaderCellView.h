//
//  FTWeeksLogsHeaderCellView.h
//  FitHeart
//
//  Created by Bitgears on 01/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FTWeeksLogHeaderCellView : UIView {
    UILabel* dateLabel;
    UILabel* unitLabel;
    
    NSDate* currentDate;
    NSString* currentUnit;

}

- (id)initWithFrame:(CGRect)frame withDate:(NSDate*)date withUnit:(NSString*)unit;

- (void)updateWithDate:(NSDate*)date withUnit:(NSString*)unit;


@end
