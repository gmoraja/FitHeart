//
//  FTWeeksLogsHeaderCellView.m
//  FitHeart
//
//  Created by Bitgears on 01/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FTWeeksLogHeaderCellView.h"
#import "UCFSUtil.h"

@implementation FTWeeksLogHeaderCellView

- (id)initWithFrame:(CGRect)frame withDate:(NSDate*)date withUnit:(NSString*)unit {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        currentDate = date;
        currentUnit = unit;
        
        [self initContent];
        
        [self updateWithDate:currentDate withUnit:currentUnit];

    }
    return self;
}

-(void)initContent {
    //ACTIVITY
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 160, 45)];
    dateLabel.textColor = [UIColor blackColor];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:18.0];
    dateLabel.textAlignment =  NSTextAlignmentLeft;
    dateLabel.lineBreakMode = NSLineBreakByWordWrapping;
    dateLabel.numberOfLines = 1;
    
    //VALUE
    unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(175, 0, 125, 45)];
    unitLabel.textColor = [UIColor blackColor];
    unitLabel.backgroundColor = [UIColor clearColor];
    unitLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:18.0];
    unitLabel.textAlignment =  NSTextAlignmentRight;
    unitLabel.lineBreakMode = NSLineBreakByWordWrapping;
    unitLabel.numberOfLines = 1;
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, 320, 1)];
    view.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    
    [self addSubview:dateLabel];
    [self addSubview:unitLabel];
    [self addSubview:view];
    

    
}

- (void)updateWithDate:(NSDate*)date withUnit:(NSString*)unit {
    currentDate = date;
    currentUnit = unit;
    
    NSString* dateStr = nil;
    if ([UCFSUtil isToday:date])
        dateStr = @"Today";
    else
        if ([UCFSUtil isYesterday:date])
            dateStr = @"Yesterday";
        else {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE MMM dd"];
            dateStr = [dateFormatter stringFromDate:date];
        }
    dateLabel.text = dateStr;
    
    unitLabel.text = unit;
    
    
    
}



@end
