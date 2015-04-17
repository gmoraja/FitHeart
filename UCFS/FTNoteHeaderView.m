//
//  MoodNoteHeaderView.m
//  FitHeart
//
//  Created by Bitgears on 27/12/13.
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

#import "FTNoteHeaderView.h"


@interface FTNoteHeaderView() {
    UIImage* arrowUpImage;
    UIImage* arrowDownImage;
    UIImage* arrowRightImage;
    UIImageView* arrowImageView;
}

@end



@implementation FTNoteHeaderView

@synthesize delegate;
@synthesize section;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withLabel:(NSString*)label withLabelColor:(UIColor*)labelColor {
    self = [super initWithFrame:frame];
    if (self) {
        arrowDownImage = [UIImage imageNamed:@"arrow_down.png"];
        arrowUpImage = [UIImage imageNamed:@"arrow_up.png"];
        arrowRightImage = [UIImage imageNamed:@"arrow_right.png"];
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self initContentWithLabel:label withLabelColor:labelColor];
        
        UIImageView *aLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height-1, frame.size.width, 1)];
        [aLine setImage:[UIImage imageNamed:@"dotted_line"]];
        [self addSubview:aLine];
        
        [self setUserInteractionEnabled:YES];
        [self setAccessibilityLabel:[NSString stringWithFormat:@"%@ button", label]];
        [self setIsAccessibilityElement: YES];
        
        
    }
    return self;
}

-(void)initContentWithLabel:(NSString*)label withLabelColor:(UIColor*)labelColor {
    
    
    //label
    float offset_x = 20;
    float offset_y = (self.frame.size.height-20)/2;
    headerlabel = [[UILabel alloc] initWithFrame:CGRectMake(offset_x, offset_y, 280, 20)];
    headerlabel.textColor = labelColor;
    headerlabel.backgroundColor = [UIColor clearColor];
    headerlabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:16.0];
    headerlabel.text = [label uppercaseString];
    headerlabel.textAlignment = ALIGN_LEFT;
    headerlabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    /*
    offset_x = self.frame.size.width - arrowImage.size.width - 15;
    offset_y = (self.frame.size.height - arrowImage.size.height) / 2;
    headerButton = [[UIButton alloc] initWithFrame:CGRectMake(offset_x, offset_y, arrowImage.size.width, arrowImage.size.height)];
     */
    offset_x = self.frame.size.width - arrowDownImage.size.width - 15;
    offset_y = (self.frame.size.height - arrowDownImage.size.height) / 2;
    arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(offset_x, offset_y, arrowDownImage.size.width, arrowDownImage.size.height)];
    [arrowImageView setImage:arrowDownImage];
    arrowImageView.userInteractionEnabled = NO;
    
    [self addSubview:headerlabel];
    [self addSubview:arrowImageView];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [tapRecognizer setNumberOfTapsRequired:1];
    [self addGestureRecognizer:tapRecognizer];
    
    
}

-(void)handleTap:(UITapGestureRecognizer *)recognizer {
    [self.delegate clickHeaderView:self withSection:section];
}

-(void)setAsOpened {
    //[arrowImageView setImage:arrowUpImage];
    //[self setAccessibilityValue:@" expanded"];
    //[self setAccessibilityHint:@"Tap to close"];
    [arrowImageView setImage:arrowRightImage];
    [self setAccessibilityHint:@"Tap to view content"];

}

-(void)setAsClosed {
    //[arrowImageView setImage:arrowDownImage];
    //[self setAccessibilityValue:@" not expanded"];
    //[self setAccessibilityHint:@"Tap to open"];
    [arrowImageView setImage:arrowRightImage];
    [self setAccessibilityHint:@"Tap to view content"];

}

-(void)hideArrow {
    arrowImageView.hidden = YES;
}



@end
