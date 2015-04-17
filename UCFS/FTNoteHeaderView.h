//
//  MoodNoteHeaderView.h
//  FitHeart
//
//  Created by Bitgears on 27/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FTNoteHeaderDelegate
- (void)clickHeaderView:(UIView*)headerView withSection:(int)section;

@end

@interface FTNoteHeaderView : UIView {
    UILabel *headerlabel;
    int section;
}

@property (assign) id <FTNoteHeaderDelegate> delegate;
@property (assign) int section;

- (id)initWithFrame:(CGRect)frame withLabel:(NSString*)label withLabelColor:(UIColor*)labelColor;
-(void)setAsOpened;
-(void)setAsClosed;

-(void)hideArrow;

@end
