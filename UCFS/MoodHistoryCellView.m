//
//  MoodHistoryCellView.m
//  FitHeart
//
//  Created by Bitgears on 06/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "MoodHistoryCellView.h"
#import "UCFSUtil.h"

static float INFO_WIDTH = 78.0;
static float MAX_BAR_WIDTH = 242.0;
static float MOOD_IMAGE_WIDTH = 39.0;


@interface MoodHistoryCellView() {
}

@end

@implementation MoodHistoryCellView

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withLogData:(FTLogData*)logData {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        currentSection = section;
        
        bkgImageView = [[UIImageView alloc] initWithFrame:frame];
        [bkgImageView setImage:[UIImage imageNamed:@"mood_history_cell_bkg"]];
        bkgImageView.tag = 1;
        
        
        dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, INFO_WIDTH, frame.size.height)];
        dateLabel.textColor = [UIColor blackColor];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textAlignment =  NSTextAlignmentCenter;
        dateLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:(14.0)];
        
        [self addSubview:bkgImageView];
        [self addSubview:dateLabel];
        
        [self updateWithLogData:logData];
        
    }
    return self;
}

- (void)updateWithLogData:(FTLogData*)logData {
    currentLogData = logData;

    dateLabel.text = [UCFSUtil formatDate:logData.insertDate withFormat:@"MMM dd"];
    
    int moodValue = (int)(logData.logValue);
    CGRect moodRect = CGRectMake(INFO_WIDTH+5+ (moodValue*(MOOD_IMAGE_WIDTH+10)), 5, MOOD_IMAGE_WIDTH, MOOD_IMAGE_WIDTH);
    moodImageView = [[UIImageView alloc] initWithFrame:moodRect];
    switch (moodValue) {
        case 0: [moodImageView setImage:[UIImage imageNamed:@"mood_smile_5_graph"]];  break;
        case 1: [moodImageView setImage:[UIImage imageNamed:@"mood_smile_4_graph"]];  break;
        case 2: [moodImageView setImage:[UIImage imageNamed:@"mood_smile_3_graph"]];  break;
        case 3: [moodImageView setImage:[UIImage imageNamed:@"mood_smile_2_graph"]];  break;
        case 4: [moodImageView setImage:[UIImage imageNamed:@"mood_smile_1_graph"]];  break;
    }
    [self addSubview:moodImageView];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
