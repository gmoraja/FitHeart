//
//  FTDataType.h
//  FitHeart
//
//  Created by Bitgears on 19/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTDataType : NSObject {
    int goaltypeId;
    NSString* name;
    int unit;

}

@property (nonatomic,assign) int goaltypeId;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) int unit;


@end
