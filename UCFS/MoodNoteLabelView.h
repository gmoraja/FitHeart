//
//  MoodNoteLabelView.h
//  FitHeart
//
//  Created by Bitgears on 24/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;


@interface MoodNoteLabelView : UILabel 

@property (nonatomic, readwrite) VerticalAlignment verticalAlignment;

@end
