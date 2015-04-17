//
//  FTDoubleHeaderView.h
//  FitHeart
//
//  Created by Bitgears on 11/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTHeaderView.h"
#import "FTHeaderConf.h"

@protocol FTDoubleHeaderProtocol
- (void)activeValue:(int)valueType;
@end

@interface FTDoubleHeaderView : FTHeaderView {
    UILabel *value2Label;
    UITextField *value2Text;
    NSString* value2Unit;
    
    UIImageView* pencil2ImageView;


}

@property (weak) id <FTDoubleHeaderProtocol> delegate;

@property (strong,nonatomic) UILabel *value2Label;
@property (strong,nonatomic) UITextField *value2Text;
@property (strong,nonatomic) NSString* value2Unit;

- (id)initWithFrame:(CGRect)frame withConf:(FTHeaderConf*)headerConf;
-(void)switchWithActiveValue:(int)activeValue;

@end
