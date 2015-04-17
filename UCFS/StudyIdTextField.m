//
//  StudyIdTextField.m
//  FitHeart
//
//  Created by Bitgears on 23/06/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "StudyIdTextField.h"

@implementation StudyIdTextField

- (void)setup {
    self.edgeInsets = UIEdgeInsetsMake(0, 26, 0, 0);
    UIImage *fieldBGImage = [[UIImage imageNamed:@"studyidbkg"] stretchableImageWithLeftCapWidth:20 topCapHeight:20];
    [self setBackground:fieldBGImage];
    [self setStyle];
    //self.textAlignment = NSTextAlignmentLeft;
 }

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setup];
    }
    return self;
}



- (void)setStyle {
    if (self!=nil && self.text!=nil) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
        [attributedString addAttribute:NSKernAttributeName value:@(26) range:NSMakeRange(0, self.text.length)];
        self.attributedText = attributedString;

       
        
        self.font = [UIFont fontWithName:@"SourceSansPro-Semibold" size:52.0];
        self.textColor = [UIColor colorWithRed:0.0/255.0 green:108.0/255.0 blue:136.0/255.0 alpha:1.0];
        
    }
    
}

- (void) drawTextInRect:(CGRect)rect {
    //[self setStyle];
    [super drawTextInRect:rect];
}


- (CGRect)textRectForBounds:(CGRect)bounds {

    return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [super editingRectForBounds:UIEdgeInsetsInsetRect(bounds, self.edgeInsets)];
}

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    return CGRectZero;
}


@end
