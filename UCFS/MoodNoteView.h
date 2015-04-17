//
//  MoodNoteView.h
//  FitHeart
//
//  Created by Bitgears on 22/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTNoteData.h"
#import "MoodNoteLabelView.h"

@protocol MoodNoteDelegate
- (void)deleteNote:(FTNoteData*)note withView:(UIView*)view;
- (void)editNote:(FTNoteData*)note withView:(UIView*)view;;
@end


@interface MoodNoteView : UIView {
    UILabel* dateLabel;
    MoodNoteLabelView* textLabel;
    
    FTNoteData* note;
    
    
}

@property (assign) id <MoodNoteDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withNote:(FTNoteData*)noteData;
- (void)updateWithNote:(FTNoteData*)noteData;
- (void)closeDelete;
- (void)openDelete;

@end
