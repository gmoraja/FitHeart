//
//  FTTimeFrequencySlider.h
//  FitHeart
//
//  Created by Bitgears on 02/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>




@protocol FTFrequencySliderDelegate
- (void)frequencyChanged:(int)frequency;
@end


@interface FTFrequencySlider : UIControl {
    int position;
}

@property (nonatomic,assign) int position;
@property (strong, nonatomic) UIColor* handleColor;
@property (nonatomic,assign) CGFloat handleSize;
@property (strong, nonatomic) UIColor* handleInternalColor;
@property (nonatomic,assign) CGFloat handleInternalSize;
@property (weak) id <FTFrequencySliderDelegate> delegate;

- (id)initWithFrame:(CGRect)frame withPositions:(NSArray*)pos;

-(void)updatePosition:(int)newpos;

@end
