//
//  FTNote.h
//  FitHeart
//
//  Created by Bitgears on 17/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTNote : NSObject {
    int uniqueId;    
    NSString* note;
    NSString* noteAcc;
    NSString* linkAcc;
    CGSize size;
}

@property (nonatomic,assign) int uniqueId;
@property (nonatomic,strong) NSString* note;
@property (nonatomic,strong) NSString* noteAcc;
@property (nonatomic,strong) NSString* linkAcc;
@property (nonatomic,assign) CGSize size;


@end
