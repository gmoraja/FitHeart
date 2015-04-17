//
//  FTNoteHeader.h
//  FitHeart
//
//  Created by Bitgears on 17/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTNoteHeader : NSObject {
    int uniqueId;      
    NSString* label;
    NSMutableArray* notes;
    BOOL isExpanded;
}

@property (nonatomic,assign) int uniqueId;
@property (nonatomic,strong) NSString* label;
@property (nonatomic,strong) NSMutableArray* notes;
@property (nonatomic,assign) BOOL isExpanded;

- (id)initWithId:(int)uniqueid withLabel:(NSString*)labeltext;


@end
