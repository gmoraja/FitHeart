//
//  UITextArc.h
//  FitHeart
//
//  Created by Bitgears on 21/11/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    TEXTARC_ORIEN_INTERNAL        = 0,
    TEXTARC_ORIEN_EXTERNAL        = 1
}; typedef NSUInteger UITextArcOrientation;

enum {
    TEXTARC_ALIGN_LEFT         = 0,
    TEXTARC_ALIGN_CENTER       = 1,
    TEXTARC_ALIGN_RIGHT        = 2
}; typedef NSUInteger UITextArcAlignment;

@interface UITextArc : UIControl

    @property (strong, nonatomic) NSString* text;
    @property (nonatomic,assign) float angle;
    @property (nonatomic,assign) float radius;
    @property (nonatomic,assign) UITextArcAlignment textAlignment;
    @property (strong, nonatomic) UIColor* color;
    @property (nonatomic,assign) UITextArcOrientation textOrientation;

-(id)initWithFrame:(CGRect)frame withFontName:(NSString*)fontName withFontSize:(float)fontSize;


@end
