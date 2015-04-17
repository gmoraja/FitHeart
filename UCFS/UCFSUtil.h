//
//  UCFSUtil.h
//  FitHeart
//
//  Created by Bitgears on 11/11/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#ifdef __IPHONE_6_0
# define ALIGN_CENTER NSTextAlignmentCenter
#else
# define ALIGN_CENTER UITextAlignmentCenter
#endif

#import <Foundation/Foundation.h>
#import "FTSection.h"
#import "TBCircularSlider.h"
#import "FTFrequencySlider.h"
#import "AFPickerView.h"
#import "FTCircularTimerSlider.h"
#import "FTReminderData.h"
#import "FTLogGroupedData.h"


@interface UCFSUtil : NSObject

//############# SYSTEM

+ (void) printFonts;
+ (BOOL)deviceSystemIOS7;
+ (BOOL)deviceIs3inch;
+ (BOOL)deviceIsRetina;
+ (float)fullContentAreaHeight;
+ (float)contentAreaHeight;
+ (float) bottomPositionWithViewHeight:(float)height;
+ (UIImage *)imageWithColor:(UIColor *)color;

//############# DATE TIME UTILS

+ (NSString*)stringWithValueAsTime:(float)value;
+ (NSString*)stringWithValue:(float)value formatAsFloat:(BOOL)asFloat formatAsCompact:(BOOL)asCompact;
+ (NSString*)formatLogDate:(FTLogGroupedData*)logData;
+ (NSString*)formatDay:(NSDate*)date;
+ (NSString*)formatMonthWithIndex:(int)month;
+ (NSString*)formatDateTime:(NSDate*)date;
+ (NSString*)formatDateTimeGmt:(NSDate*)date;
+ (NSString*)formatDate:(NSDate*)date withFormat:(NSString*)format;
+ (NSDateComponents*)dateComp;
+ (NSDateComponents*)dateTimeComp;
+ (int)hour24From12:(int)hour withType:(int)amPm;
+ (int)numMonthWithYear:(int)year;
+ (int)numDaysWithMonth:(int)month withYear:(int)year;
+ (int)numDaysWithinCurrentMonth:(int)month withinCurrentYear:(int)year;
+ (NSDate*)getDate:(NSDate*)date addDays:(int)days;
+ (NSDate*)setTimeWithDate:(NSDate*)date withHours:(int)hour withMinutes:(int)minutes withSeconds:(int)seconds;
+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;
+ (NSDate*)dateYesterday;
+ (BOOL)isToday:(NSDate*)date;
+ (BOOL)isYesterday:(NSDate*)date;
+ (BOOL)date:(NSDate*)date isSameDay:(NSDate*)otherDate;
+ (NSInteger)daysBetween:(NSDate *)dt1 and:(NSDate *)dt2;
+ (NSString*) datetimeGMT:(NSDate*)date;

//############# FITHEART
+ (UIViewController*)getViewControllerAtStartWithNotification:(UILocalNotification*)locationNotification;
+ (UIViewController*)getViewControllerWithSection:(SectionType)sectionType withAction:(FTNotificationAction*)action;
+ (UIViewController*)getFitnessViewController;
+ (void)label:(UILabel*)label setText:(NSString*)text andCenterInRect:(CGRect)rect withFontName:(NSString*)fontName withMinFontSize:(float)minFontSize;
+ (void) initNavigationBar: (UINavigationBar*)navBar
                      item: (UINavigationItem*)navigationItem
                     title:(NSString*)title
               bkgFileName:(NSString*)bkgFileName
                 textColor:(UIColor*)textColor
            isBackVisibile:(BOOL)isBackVisibile;
+ (UIBarButtonItem*) getNavigationBarMenuButton:(NSString*)label withTarget:(id)target action:(SEL)aSelector;
+ (UIBarButtonItem*) getNavigationBarMenuDarkButton:(NSString*)label withTarget:(id)target action:(SEL)aSelector;
+ (UIBarButtonItem*) getNavigationBarCancelButtonWithTarget:(id)target action:(SEL)aSelector withTextColor:(UIColor*)textColor;
+ (UIBarButtonItem*) getNavigationBarAddButton:(NSString*)label withTarget:(id)target action:(SEL)aSelector;
+ (UIBarButtonItem*) getNavigationBarCancelButtonWithTarget:(id)target action:(SEL)aSelector withSection:(Class<FTSection>)section;
+ (UIBarButtonItem*) getNavigationBarSaveButtonWithTarget:(id)target action:(SEL)aSelector withSection:(Class<FTSection>)section;
+ (UIBarButtonItem*) getNavigationBarDoneButtonWithTarget:(id)target action:(SEL)aSelector withSection:(Class<FTSection>)section;
+ (UIBarButtonItem*) getNavigationBarReminderButtonWithTarget:(id)target action:(SEL)aSelector asDark:(BOOL)isDark;
+ (UIBarButtonItem*) getNavigationBarReminderOffButtonWithTarget:(id)target action:(SEL)aSelector asDark:(BOOL)isDark;
+ (UIBarButtonItem*) getNavigationBarActionButtonWithTarget:(id)target action:(SEL)aSelector;
+ (UIBarButtonItem*) getNavigationBarGoalReachedButtonWithTarget:(id)target action:(SEL)aSelector;
+ (UIBarButtonItem*) getNavigationBarNextButtonWithTarget:(id)target action:(SEL)aSelector withSection:(Class<FTSection>)section;
+ (UIBarButtonItem*) getNavigationBarNextButtonWithTarget:(id)target action:(SEL)aSelector withTextColor:(UIColor*)textColor;
+ (UIBarButtonItem*) getNavigationBarGoButtonWithTarget:(id)target action:(SEL)aSelector withTextColor:(UIColor*)textColor;
+ (TBCircularSlider*) createCircularSliderWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withTarget:(id)target action:(SEL)aSelector asDouble:(BOOL)isDouble;
+ (FTCircularTimerSlider*) createCircularTimeSliderWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withTarget:(id)target action:(SEL)aSelector;
+ (FTFrequencySlider*) createFrequencySliderWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withPositions:(NSArray*)positions;
+ (void)initSegmentedControl:(UISegmentedControl*)segmented withSelectedColor:(UIColor*)selectedColor;
+ (AFPickerView*)initPickerWithFrame:(CGRect)frame withSection:(Class<FTSection>)section withDatasource:(id<AFPickerViewDataSource>)dataSource withDelegate:(id<AFPickerViewDelegate>)delegate withFont:(UIFont*)font withRowHeight:(float)rowHeight withIndent:(float)rowIndent withAligment:(int)alignment withTag:(int)tag;
+ (FTReminderData*)remiderWithSection:(int)section withGoal:(int)goal;
+ (UIView*)loadingView;
+ (NSMutableArray*)noteHeadersFromJson:(NSString*)filename;
+ (NSMutableArray*)notificationsFromJson:(NSString*)filename;
+ (FTNotification*)nextLocalNotificationWithSection:(int)section withGoal:(int)goal withDateType:(int)dateType withLast:(int)lastIndex;
+ (float)normalizedValue:(float)value withDateType:(int)dateType;
+ (float)calculateMinutesFromSteps:(float)steps;
+ (float)calculateStepsFromMinutes:(float)minutes;
+ (float)calculteProgress:(NSMutableArray*)items;
+ (BOOL)syncData;
+ (NSString*)sectionName:(SectionType)sectionType withGoal:(int)goalId;
+ (void)trackGAEventWithCategory:(NSString*)category withAction:(NSString*)action withLabel:(NSString*)label withValue:(NSNumber*)value;
+ (void)setRecursiveUserInteraction:(BOOL)value inView:(UIView*)parentView;
+ (NSString *)htmlFromBodyString:(NSString *)htmlBodyString
                        textFont:(UIFont *)font
                       textColor:(UIColor *)textColor;

@end
