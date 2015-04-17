//
//  FTOptionGroupView.h
//  FitHeart
//
//  Created by Bitgears on 06/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTExpandableView.h"
#import "FTSection.h"


@protocol FTOptionGroupProtocol<NSObject>
- (void)expandedView:(UIView*)view withOptionGroup:(UIView*)optionGroupView;
- (void)collapsedView:(UIView*)view withOptionGroup:(UIView*)optionGroupView;
@optional
- (void)valueChanged;
@end

@interface FTOptionGroupView : UIView<FTExpandableProtocol> {
    
    bool openDown;
    UIView* slidableView;
    
}

@property (weak) id <FTOptionGroupProtocol> delegate;
@property (strong) UIView* slidableView;


- (id)initWithFrame:(CGRect)frame withViews:(NSArray*)allviews withOpenDirection:(float)openDirection;
- (id)initWithFrame:(CGRect)frame withViews:(NSArray*)allviews;
- (void)close;

@end


