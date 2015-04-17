//
//  FTNoteData.m
//  FitHeart
//
//  Created by Bitgears on 22/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "FTNoteData.h"

@implementation FTNoteData


@synthesize moodType;
@synthesize simplePleasure;
@synthesize insertDate;

+(FTNoteData*)initAsNoteWithText:(NSString*)text {
    FTNoteData* note = [[FTNoteData alloc] init];
    note.moodType = 0;
    note.simplePleasure = 0;
    note.insertDate = [NSDate date];
    note.note = text;
    
    return note;
}


+(FTNoteData*)initAsSimplePleasureWithType:(int)sptype withText:(NSString*)text {
    FTNoteData* note = [[FTNoteData alloc] init];
    note.moodType = 1;
    note.simplePleasure = sptype;
    note.insertDate = [NSDate date];
    note.note = text;
    
    return note;
}

@end
