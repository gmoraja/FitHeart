//
//  FTExpandableView.h
//  FitHeart
//
//  Created by Bitgears on 06/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef __IPHONE_6_0
# define ALIGN_LEFT NSTextAlignmentLeft
# define ALIGN_CENTER NSTextAlignmentCenter
# define ALIGN_RIGHT NSTextAlignmentRight
#else
# define ALIGN_LEFT UITextAlignmentLeft
# define ALIGN_CENTER UITextAlignmentCenter
# define ALIGN_RIGHT UITextAlignmentRight
#endif


@protocol FTExpandableProtocol
- (void)requestToCloseView:(UIView*)view;
- (void)requestToOpenView:(UIView*)view;
- (void)valueChanged:(int)value;

@end

@interface FTExpandableView : UIView<UIGestureRecognizerDelegate> {
    BOOL isClosed;
    
    CGRect closedRect;
    CGRect openRect;
    UIColor *closedColor;
    UIColor *openColor;
    
    UIView *contentView;
    
    bool openDown;
}

@property (assign) id <FTExpandableProtocol> delegate;
@property (assign, nonatomic) CGRect closedRect;
@property (assign, nonatomic) CGRect openRect;
@property (strong, nonatomic) UIColor *closedColor;
@property (strong, nonatomic) UIColor *openColor;

- (id)initWithFrame:(CGRect)frame withContentFrame:(CGRect)contentFrame;
- (id)initWithFrame:(CGRect)frame withContentFrame:(CGRect)contentFrame withOpenDirection:(float)openDirection;
- (void)openView;
- (void)closeView;
- (void)setLabel:(NSString*)label;
- (void)setText:(NSString*)text;
- (void)setText:(NSString*)text withColor:(UIColor*)color;
-(void)requestToClose;


@end
