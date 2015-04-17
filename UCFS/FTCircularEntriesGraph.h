//
//  FTCircularEntriesGraph.h
//  FitHeart
//
//  Created by Bitgears on 26/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTCircularEntriesGraph : UIControl {
    
}

@property (nonatomic,assign) CGFloat wheelRadius;
@property (strong, nonatomic) UIColor* wheelBackgroundColor;
@property (strong, nonatomic) UIColor* wheelForegroundColor;
@property (nonatomic,assign) CGFloat wheelBackgroundSize;

-(id)initWithFrame:(CGRect)frame withRadius:(float)wheelradius withSize:(float)size;

- (void)resetWithProgress:(float)progress withValue:(float)value withUnit:(NSString*)unit;
- (void)resetWithProgress:(float)progress withValue:(float)value withValue2:(float)value2 withUnit:(NSString*)unit;


@end
