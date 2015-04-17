//
//  FTLogListContainerView.m
//  FitHeart
//
//  Created by Bitgears on 10/02/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FTLogListContainerView.h"
#import "FTSection.h"
#import "UCFSUtil.h"
#import "FTGoalData.h"
#import "FTDateLogData.h"
#import "FitnessSection.h"
#import "HealthSection.h"
#import "NutritionSection.h"


#ifdef __IPHONE_6_0
# define ALIGN_LEFT NSTextAlignmentLeft
# define ALIGN_CENTER NSTextAlignmentCenter
# define ALIGN_RIGHT NSTextAlignmentRight
#else
# define ALIGN_LEFT UITextAlignmentLeft
# define ALIGN_CENTER UITextAlignmentCenter
# define ALIGN_RIGHT UITextAlignmentRight
#endif


float static headerHeight = 26;
float static cellHeight = 40;
float static cellInfoWidth = 110;
static int HEADERVIEW_TAG = 5;
static int DATEVIEW_TAG = 6;
static int UNITVIEW_TAG = 7;
static int CELLVIEW_TAG = 10;
static int INFOVIEW_TAG = 20;
static int INFO2VIEW_TAG = 21;
static int VALUEVIEW_TAG = 30;
static int BARVIEW_TAG = 40;
static int VALUE2VIEW_TAG = 50;
static int BAR2VIEW_TAG = 60;
static int FIXVIEW_TAG = 70;
static float MIN_BAR_WIDTH = 20;

@interface FTLogListContainerView() {
    int goalType;
    Class<FTSection> currentSection;
    FTGoalData* currentGoalData;
    FTHeaderConf *conf;
    
    UITableView *listTableView;
    UIView *bodyContainerView;
    float bodyContainerHeight;
    UIView* verticalDelimiter;
    
    UIImage* rightFixImage;
    
    float currentMaxValue;
}

@end


@implementation FTLogListContainerView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withGoalType:(int)goal {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        goalType = goal;
        currentSection = section;
        currentGoalData = [currentSection goalDataWithType:goal];
        conf = [currentSection headerConfWithGoalType:goalType];
        
        rightFixImage = [UIImage imageNamed:[currentSection rightFixImageFilename]];
        
        [self initBody];
        
        
        [self addSubview:bodyContainerView];
        
        [self updateData];
        
    }
    return self;
}

- (void)initBody {
    //Create the Circular Slider
    float tableHeight = [UCFSUtil contentAreaHeight];
    CGRect tableRect = CGRectMake(0, 0, 320, tableHeight);
    listTableView = [[UITableView alloc]initWithFrame:tableRect style:UITableViewStylePlain];
    listTableView.rowHeight = 45;
    listTableView.sectionFooterHeight = 0;
    listTableView.sectionHeaderHeight = 0;
    listTableView.scrollEnabled = YES;
    listTableView.showsVerticalScrollIndicator = YES;
    listTableView.userInteractionEnabled = YES;
    listTableView.bounces = NO;
    [listTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    listTableView.delegate = self;
    listTableView.dataSource = self;
    
    float verticalDelimiterWidth = 0.5;
    if ([UCFSUtil deviceIsRetina]==NO) verticalDelimiterWidth = 1;
    verticalDelimiter = [[UIView alloc] initWithFrame:CGRectMake(cellInfoWidth, 0, verticalDelimiterWidth, [UCFSUtil contentAreaHeight]) ];
    verticalDelimiter.backgroundColor = [UIColor lightGrayColor];
    
    
    CGRect bodyContainerRect = CGRectMake(0, 0, 320, [UCFSUtil contentAreaHeight]);
    bodyContainerView = [[UIView alloc] initWithFrame:bodyContainerRect];
    
    [bodyContainerView addSubview:listTableView];
    [bodyContainerView addSubview:verticalDelimiter];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    if (items!=nil)
        return [items count];
    else
        return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ( items!=nil && ([items count]>0) ) {
        FTDateLogData* dateLogData = (FTDateLogData*)([items objectAtIndex:section]);
        if (dateLogData!=nil)
            return [dateLogData.logs count]+1;
        else
            return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0)
        return headerHeight;
    else
        return cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        static NSString *logHeaderIdentifier = @"LogHeaderItem";
        
        FTDateLogData *dateLogData = [items objectAtIndex:indexPath.section];
  
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:logHeaderIdentifier];
        UIView* cellDataView = nil;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:logHeaderIdentifier];
            cellDataView = [self headerViewWithYear:dateLogData.year withMonh:dateLogData.month];
            [cell.contentView addSubview:cellDataView];
        }
        else
            cellDataView = [cell viewWithTag:HEADERVIEW_TAG];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        //info
        NSString* infoText = [NSString stringWithFormat:@"%@ %i", [UCFSUtil formatMonthWithIndex:dateLogData.month-1], dateLogData.year ];
        UILabel* infoLabel = (UILabel*)[cellDataView viewWithTag:DATEVIEW_TAG];
        infoLabel.text = infoText;
        //unit
        UILabel* unitLabel = (UILabel*)[cellDataView viewWithTag:UNITVIEW_TAG];
        unitLabel.text = conf.unit;
        
        return cell;
    }
    else {
        static NSString *cellHeaderIdentifier = @"CellHeaderItem";

        FTDateLogData *dateLogData = [items objectAtIndex:indexPath.section];
        FTLogData* item = [dateLogData.logs objectAtIndex:indexPath.row-1];
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellHeaderIdentifier];
        UIView* cellDataView = nil;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellHeaderIdentifier];
            cellDataView = [self cellDataViewWithLog:item];
            [cell.contentView addSubview:cellDataView];
        }
        else
            cellDataView = [cell viewWithTag:CELLVIEW_TAG];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        //background
        if (indexPath.row % 2)
            [cellDataView setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0]];
        else
            [cellDataView setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
        //info
        UILabel* infoLabel = (UILabel*)[cellDataView viewWithTag:INFOVIEW_TAG];
        infoLabel.text = [UCFSUtil formatDay:item.insertDate];
        //info 2
        UILabel* info2Label = (UILabel*)[cellDataView viewWithTag:INFO2VIEW_TAG];
        if (item.section==SECTION_FITNESS) info2Label.text = [[FitnessSection getActivities] objectAtIndex:item.activity];
        else
            if (item.section==SECTION_HEALTH) info2Label.text = [[HealthSection getGlucoseTimes] objectAtIndex:item.meal];
        //bar
        UIView* barView = (UIView*)[cellDataView viewWithTag:BARVIEW_TAG];
        barView.backgroundColor = [currentSection mainColor:0];
        /*
         if (indexPath.row==0)
         barView.backgroundColor = [currentSection mainColor:0];
         else
         barView.backgroundColor = [UIColor lightGrayColor];
         */
        //value
        UILabel* valueLabel = (UILabel*)[cellDataView viewWithTag:VALUEVIEW_TAG];
        NSString* valueText = @"";
        //calculate bar values
        UIImageView* rightFixImageView = (UIImageView*)[cellDataView viewWithTag:FIXVIEW_TAG];
        float barWidth = 0;
        if (item.logValue>0) {
            if (item.logValue<=currentMaxValue) {
                barWidth = [self barWidthWithLogValue:item.logValue];
                rightFixImageView.hidden = YES;
            }
            else {
                barWidth = [self barWidthWithLogValue:item.logValue] - 30;
                rightFixImageView.hidden = NO;
            }
            //fix for double values
            valueText = [UCFSUtil stringWithValue:item.logValue formatAsFloat:FALSE formatAsCompact:FALSE];
        }
        barView.frame = CGRectMake(cellInfoWidth,0, barWidth, cellHeight);
        valueLabel.text = valueText;
        valueLabel.frame = CGRectMake(cellInfoWidth,0, barWidth-5, cellHeight);
        
        //bar2
        UIView* bar2View = (UIView*)[cellDataView viewWithTag:BAR2VIEW_TAG];
        if (bar2View!=nil) {
            //if (indexPath.row==0)
                bar2View.backgroundColor = [currentSection circularBottomTextColor];
            //else
                //bar2View.backgroundColor = [UIColor grayColor];
        }
        

        
        //value2
        UILabel* value2Label = (UILabel*)[cellDataView viewWithTag:VALUE2VIEW_TAG];
        NSString* value2Text = @"";
        //calculate bar values
        float bar2Width = 0;
        if (bar2View!=nil) bar2View.frame = CGRectMake(cellInfoWidth,0, bar2Width, cellHeight);
        if (value2Label!=nil) {
            value2Label.text = value2Text;
            value2Label.frame = CGRectMake(cellInfoWidth,0, bar2Width-5, cellHeight);
        }
        
        return cell;
    }

}

-(float)barWidthWithLogValue:(float)value {
    float barWidth = MIN_BAR_WIDTH;
    
    if (value>0) {
        //if (currentGoalData!=nil) {
            if (currentMaxValue>0)
                barWidth = (value * (320-cellInfoWidth))/currentMaxValue;
            if (barWidth>(320-cellInfoWidth))
                barWidth = (320-cellInfoWidth);
            else if (barWidth<MIN_BAR_WIDTH)
                barWidth = MIN_BAR_WIDTH;
        //}
        //else
            //barWidth = (320-cellInfoWidth) / 2;
    }
    
    return barWidth;
}

-(UIView*)headerViewWithYear:(int)year withMonh:(int)month {
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, headerHeight)];
    headerView.backgroundColor = [UIColor lightGrayColor];
    headerView.tag = HEADERVIEW_TAG;
    
    UILabel* infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, cellInfoWidth-5, headerHeight)];
    infoLabel.textColor = [UIColor whiteColor];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.font = [UIFont fontWithName:@"Futura-CondensedMedium" size:(14.0)];
    infoLabel.textAlignment =  ALIGN_RIGHT;
    infoLabel.text = [NSString stringWithFormat:@"%@ %i", [UCFSUtil formatMonthWithIndex:month-1], year ] ;
    infoLabel.tag = DATEVIEW_TAG;
    
    UILabel* minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellInfoWidth,0, 320-cellInfoWidth, headerHeight)];
    minuteLabel.textColor = [UIColor whiteColor];
    minuteLabel.backgroundColor = [UIColor clearColor];
    minuteLabel.font = [UIFont fontWithName:@"Futura-CondensedMedium" size:(14.0)];
    minuteLabel.textAlignment =  ALIGN_LEFT;
    minuteLabel.text = conf.unit;
    minuteLabel.tag = UNITVIEW_TAG;
    
    [headerView addSubview:infoLabel];
    [headerView addSubview:minuteLabel];
    
    return headerView;
}


-(UIView*)cellDataViewWithLog:(FTLogData*)logData {
    UIView* cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, cellHeight)];
    cellView.tag = CELLVIEW_TAG;
    // even
    
    UILabel* infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0, cellInfoWidth-5, cellHeight)];
    infoLabel.textColor = [UIColor grayColor];
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.font = [UIFont fontWithName:@"Futura-CondensedMedium" size:(14.0)];
    infoLabel.textAlignment =  ALIGN_RIGHT;
    infoLabel.text = [UCFSUtil formatDay:logData.insertDate];
    infoLabel.tag = INFOVIEW_TAG;
    
    
    if (
            (logData.section==SECTION_FITNESS && logData.goalType==0) || /* time */
            (logData.section==SECTION_HEALTH && logData.goalType==3)  /* glucose */
        ) {
        
        
        infoLabel.frame = CGRectMake(0,0, cellInfoWidth-5, cellHeight/2);
        
        UILabel* info2Label = [[UILabel alloc] initWithFrame:CGRectMake(0,cellHeight/2-2, cellInfoWidth-5, cellHeight/2)];
        info2Label.textColor = [currentSection darkColor:-1];
        info2Label.backgroundColor = [UIColor clearColor];
        info2Label.font = [UIFont fontWithName:@"Futura-CondensedMedium" size:(14.0)];
        info2Label.textAlignment =  ALIGN_RIGHT;
        info2Label.tag = INFO2VIEW_TAG;
        
        if (logData.section==SECTION_FITNESS) info2Label.text = [[FitnessSection getActivities] objectAtIndex:logData.activity];
        else
            if (logData.section==SECTION_HEALTH) info2Label.text = [[HealthSection getGlucoseTimes] objectAtIndex:logData.meal];
        
        [cellView addSubview:infoLabel];
        [cellView addSubview:info2Label];
        
    }
    else {
        [cellView addSubview:infoLabel];
    }
    
    
    //NSIndexPath *firstVisibleIndexPath = [[listTableView indexPathsForVisibleRows] objectAtIndex:0];
    
    float barWidth = [self barWidthWithLogValue:logData.logValue];
    UIView *barView = [[UILabel alloc] initWithFrame:CGRectMake(cellInfoWidth,0, barWidth, cellHeight-1)];
    barView.tag = BARVIEW_TAG;
    [cellView addSubview:barView];
    
    UIImageView* rightFixImageView = [[UIImageView alloc] initWithImage:rightFixImage];
    rightFixImageView.frame = CGRectMake(320-rightFixImage.size.width, 0, rightFixImage.size.width, rightFixImage.size.height);
    rightFixImageView.tag = FIXVIEW_TAG;
    [cellView addSubview:rightFixImageView];
    
    UILabel* valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(cellInfoWidth,0, barView.frame.size.width-5, cellHeight-1)];
    valueLabel.textColor = [UIColor whiteColor];
    valueLabel.backgroundColor = [UIColor clearColor];
    valueLabel.font = [UIFont fontWithName:@"Futura-CondensedMedium" size:(14.0)];
    valueLabel.textAlignment =  ALIGN_RIGHT;
    valueLabel.text = [UCFSUtil stringWithValue:logData.logValue formatAsFloat:FALSE formatAsCompact:FALSE];
    valueLabel.tag = VALUEVIEW_TAG;
    [cellView addSubview:valueLabel];
    

    
    
    UIImageView *aLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, cellHeight-2, 320, 2)];
    aLine.backgroundColor = [UIColor whiteColor];
    //[aLine setImage:[UIImage imageNamed:@"dotted_line"]];
    
    
    [cellView addSubview:aLine];
    
    return cellView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (items!=nil && [items count]>0 && indexPath.section<[items count]) {
        FTDateLogData *dateLogData = [items objectAtIndex:indexPath.section];
        if (dateLogData!=nil && dateLogData.logs!=nil && [dateLogData.logs count]>0 && indexPath.row<=[dateLogData.logs count]) {
            FTLogData* item = [dateLogData.logs objectAtIndex:indexPath.row-1];
            if (item!=nil)
                [self.delegate buttonEntryTouchWithDate:item];
        }
    }
}

-(void)updateData {
    NSLog(@"updateData");
    items = nil;
    //items = [currentSection loadEntries:-1 wi];
    [listTableView reloadData];
    
    if (currentGoalData!=nil) {
        float normalizedGoalValue1;
        //NSString* unit = conf.unit;
        if (conf.normalizeValue) {
            normalizedGoalValue1 = [UCFSUtil normalizedValue:currentGoalData.goalValue withDateType:0];
            //unit = [self normalizedUnit:unit withDateType:0];
        }
        else {
            normalizedGoalValue1 = currentGoalData.goalValue;
        }
        
        currentMaxValue = normalizedGoalValue1 * 100 / 70;
    }
    else {
        currentMaxValue = [currentSection maxLogValueWithGoal:goalType];
    }
}


- (void)expandedView:(UIView*)view withOptionGroup:(UIView*)optionGroupView {
    
}

- (void)collapsedView:(UIView*)view withOptionGroup:(UIView*)optionGroupView {
    
}

- (void)valueChanged {
    [self updateData];
    
}


@end
