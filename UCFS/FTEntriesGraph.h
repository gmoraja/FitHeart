//
//  FTEntriesGraph.h
//  FitHeart
//
//  Created by Bitgears on 05/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FTEntriesGraphDelegate
- (void)onTappedSelectedEntry;
@end

@interface FTEntriesGraph : UIControl {
    NSArray *items;
    int selectedIndex;
    float goalValue;
    float maxValue;
    BOOL goalValueImageVisible;
    BOOL formatValueAsFloat;
    BOOL formatValueAsCompact;
    UIColor* barColor;
    UIColor* bar2Color;
    UIColor* barOverflowColor;
    UIColor* bar2OverflowColor;
    BOOL isTappable;
    BOOL clipInElipse;
    
}

@property (strong)  NSArray *items;
@property (assign, nonatomic)  int selectedIndex;
@property (assign, nonatomic)  BOOL goalValueImageVisible;
@property (assign, nonatomic)  float goalValue;
@property (assign, nonatomic)  float maxValue;
@property (assign, nonatomic)  BOOL formatValueAsFloat;
@property (assign, nonatomic)  BOOL formatValueAsCompact;
@property (weak) id <FTEntriesGraphDelegate> delegate;
@property (strong)  UIColor* barColor;
@property (strong)  UIColor* bar2Color;
@property (strong)  UIColor* barOverflowColor;
@property (strong)  UIColor* bar2OverflowColor;
@property (assign, nonatomic)  BOOL isTappable;
@property (assign, nonatomic)  BOOL clipInElipse;

- (id)initWithFrame:(CGRect)frame withBarWidth:(float)barwidth withMaxLimitImage:(NSString*)maxLimitImageFile withTopFixImage:(NSString*)topFixImageFile withTopFixNonTappableImage:(NSString*)topFixNonTappableImageFile;

- (void)resetWithEntries:(NSMutableArray*)entries valueAsFloat:(BOOL)isFloat valueAsCompact:(BOOL)isCompact;

@end
