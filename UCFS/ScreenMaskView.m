//
//  ScreenMaskView.m
//  FitHeart
//
//  Created by Bitgears on 29/12/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "ScreenMaskView.h"

@implementation ScreenMaskView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        self.accessibilityViewIsModal = YES;
    }
    return self;
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //EZDEBUG(@"eater touched");
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
