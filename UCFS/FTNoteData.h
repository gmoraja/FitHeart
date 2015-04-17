//
//  FTNoteData.h
//  FitHeart
//
//  Created by Bitgears on 22/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FTNote.h"

@interface FTNoteData : FTNote {
    

    int moodType;
    int simplePleasure;
    NSDate* insertDate;

}


@property (nonatomic,assign) int moodType;
@property (nonatomic,assign) int simplePleasure;
@property (nonatomic,strong) NSDate* insertDate;

+(FTNoteData*)initAsNoteWithText:(NSString*)text;
+(FTNoteData*)initAsSimplePleasureWithType:(int)sptype withText:(NSString*)text;

@end
