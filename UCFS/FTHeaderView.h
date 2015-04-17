//
//  FTHeaderView.h
//  FitHeart
//
//  Created by Bitgears on 12/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//


#ifdef __IPHONE_6_0
# define ALIGN_LEFT NSTextAlignmentLeft
# define ALIGN_CENTER NSTextAlignmentCenter
# define ALIGN_RIGHT NSTextAlignmentRight
#else
# define ALIGN_LEFT UITextAlignmentLeft
# define ALIGN_CENTER UITextAlignmentCenter
# define ALIGN_RIGHT UITextAlignmentRight
#endif


#import <UIKit/UIKit.h>
#import "FTHeaderConf.h"


@interface FTHeaderView : UIView {
    float valueTextHeight;
    float labelTextHeight;
    float valueTextWidth;
    float labelTextWidth;
    
    float labelPadding;
    FTHeaderConf *conf;

    UITextField *valueText;
    UILabel* valueLabel;
    NSString* valueUnit;
    
    BOOL editModeEnabled;
    
    int arrowType; //0=none, 1=up, 2=down
    
    UIImageView* pencilImageView;
    
}

@property (strong, nonatomic) FTHeaderConf *conf;
@property (strong, nonatomic) UITextField *valueText;
@property (strong, nonatomic) UILabel *valueLabel;
@property (assign, nonatomic) BOOL editModeEnabled;
@property (assign, nonatomic) int arrowType;
@property (strong, nonatomic) UIImageView* arrowImageView;
@property (strong, nonatomic) NSString* valueUnit;

- (id)initWithFrame:(CGRect)frame withConf:(FTHeaderConf*)headerConf;
- (void)editText;
- (void)editMode:(BOOL)edit withValueIndex:(int)activeValue;
- (void)updateConf:(FTHeaderConf*)headerConf;
-(void)showPencil:(BOOL)show withValueIndex:(int)activeValue;

@end
