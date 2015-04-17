//
//  FTNoteHeader.m
//  FitHeart
//
//  Created by Bitgears on 17/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FTNoteHeader.h"

@implementation FTNoteHeader

@synthesize uniqueId;
@synthesize label;
@synthesize notes;
@synthesize isExpanded;

- (id)initWithId:(int)uniqueid withLabel:(NSString*)labeltext {
    self = [super init];
    if (self){
        self.uniqueId = uniqueid;
        self.label = labeltext;
        self.isExpanded = FALSE;
        self.notes = [NSMutableArray array];
    }
    return self;
}



@end
