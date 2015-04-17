//
//  FTWeeksLogCellView.m
//  FitHeart
//
//  Created by Bitgears on 01/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FTWeeksLogCellView.h"
#import "FitnessSection.h"
#import "UCFSUtil.h"

static  float deleteContentWidth = 44;

@interface FTWeeksLogCellView() {
    
    UIView* containerView;
    UIView* contentView;
    UIView* deleteView;
    UIButton* deleteButton;
    
    bool deleteViewIsHidden;

}

@end

@implementation FTWeeksLogCellView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withGoalData:(FTGoalData*)goalData withLogData:(FTLogData*)logData
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        currentSection = section;
        goal = goalData;
        log = logData;
        deleteViewIsHidden = TRUE;
        
        CGRect mainFrame = CGRectMake(0, 0, self.frame.size.width+deleteContentWidth, self.frame.size.height);
        containerView = [[UIView alloc] initWithFrame:mainFrame];
        
        containerView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
        
        [self initDelete];
        [self initContent];
        
        [self addSubview:containerView];
        
    }
    return self;
}

-(void)initDelete {
    CGRect deleteFrame = CGRectMake(self.frame.size.width, 0, deleteContentWidth, self.frame.size.height);
    deleteView = [[UIView alloc] initWithFrame:deleteFrame];
    deleteView.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:209.0/255.0 blue:159.0/255.0 alpha:1.0];
    
    UIImage *deleteImage = [UIImage imageNamed:@"delete_list_entry"];
    float x_center = (deleteFrame.size.width - deleteImage.size.width) / 2;
    float y_center = (deleteFrame.size.height - deleteImage.size.height) / 2;
    deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(x_center,y_center, deleteImage.size.width, deleteImage.size.height)];
    [deleteButton setBackgroundImage:deleteImage forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    [deleteButton setAccessibilityLabel:@"Delete"];
    [deleteButton setAccessibilityHint:@"Tap to delete the current log"];
    
    [deleteView addSubview:deleteButton];
    
    [containerView addSubview:deleteView];
    
}


-(void)initContent {
    
    CGRect contentFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    contentView = [[UIView alloc] initWithFrame:contentFrame];
    //contentView.backgroundColor = [UIColor redColor];
    
    //ACTIVITY
    activityLabel = [[UILabel alloc] initWithFrame:CGRectMake(44, 0, 160, 40)];
    activityLabel.textColor = [currentSection mainColor:-1];
    activityLabel.backgroundColor = [UIColor clearColor];
    activityLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:20.0];
    activityLabel.textAlignment =  NSTextAlignmentLeft;
    activityLabel.lineBreakMode = NSLineBreakByWordWrapping;
    activityLabel.numberOfLines = 1;
    
    //VALUE
    valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 95, 40)];
    valueLabel.textColor = [UIColor blackColor];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:20.0];
    valueLabel.textAlignment =  NSTextAlignmentRight;
    valueLabel.lineBreakMode = NSLineBreakByWordWrapping;
    valueLabel.numberOfLines = 1;
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleFingerTap.cancelsTouchesInView = NO;
    [containerView addGestureRecognizer:singleFingerTap];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    swipeLeft.cancelsTouchesInView = NO;
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [containerView addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    swipeRight.cancelsTouchesInView = NO;
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [containerView addGestureRecognizer:swipeRight];
    

    [contentView setIsAccessibilityElement:YES];
    [contentView setAccessibilityLabel:@"log "];
    [contentView setAccessibilityHint:@"tap to edit log"];
    
    [contentView addSubview:activityLabel];
    [contentView addSubview:valueLabel];
    contentView.clipsToBounds = YES;
    
    [containerView addSubview:contentView];

    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, 320, 1)];
    view.backgroundColor = [UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    [containerView addSubview:view];
    
    
    
    [self updateWithGoalData:goal withLogData:log];
    
    
}

- (void)updateWithGoalData:(FTGoalData*)goalData withLogData:(FTLogData*)logData {
    
    goal = goalData;
    log = logData;
    
    NSString* activityStr = @"activity";
    if ([currentSection sectionType]==SECTION_FITNESS) {
        NSArray* activities = [FitnessSection getActivities];
        if (log.activity<[activities count] )
            activityStr = [activities objectAtIndex:log.activity];
    }
    activityLabel.text = activityStr;
    [activityLabel setIsAccessibilityElement:NO];

    int value = (int)(log.logValue);
    NSString* unit = @"minutes";
    if ([currentSection sectionType]==SECTION_FITNESS && log.goalType==1) {
        unit = @"steps";
        //value = (int)[UCFSUtil calculateMinutesFromSteps:log.logValue];
    }
    valueLabel.text = [NSString stringWithFormat:@"%i", value];
    [valueLabel setIsAccessibilityElement:NO];

    [contentView setAccessibilityValue:[NSString stringWithFormat:@"activity %@ value %i %@",  activityLabel.text, value, unit]];

}


-(IBAction)deleteAction:(id)sender {
    [self.delegate deleteLog:log withView:self];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:containerView];
    if (location.x>=0 && location.x<=(containerView.frame.size.width-deleteContentWidth))
        [self.delegate editLog:log withView:self];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    if([recognizer direction] == UISwipeGestureRecognizerDirectionRight) {
        if (deleteViewIsHidden==FALSE)
            [self closeDelete];
    }else{
        if (deleteViewIsHidden==TRUE)
            [self openDelete];
    }
}

-(void)openDelete {
    deleteViewIsHidden = FALSE;
    [UIView animateWithDuration:0.5f animations:^{
        CGRect newTempRect = CGRectMake(containerView.frame.origin.x-deleteContentWidth, containerView.frame.origin.y, containerView.frame.size.width, containerView.frame.size.height);
        containerView.frame = newTempRect;
        
    }completion:^(BOOL finished) {
        
    }];
}

-(void)closeDelete {
    deleteViewIsHidden = TRUE;
    [UIView animateWithDuration:0.5f animations:^{
        CGRect newTempRect = CGRectMake(containerView.frame.origin.x+deleteContentWidth, containerView.frame.origin.y, containerView.frame.size.width, containerView.frame.size.height);
        containerView.frame = newTempRect;
        
    }completion:^(BOOL finished) {
    }];
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
