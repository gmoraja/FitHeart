//
//  FTExpandableView.m
//  FitHeart
//
//  Created by Bitgears on 06/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "FTExpandableView.h"
#import "UCFSUtil.h"

@interface FTExpandableView() {
    UILabel *mainLabel;
    UILabel *textLabel;
    UIImage* arrowUpImage;
    UIImage* arrowDownImage;
    UIImageView* arrowImage;
    CGRect tappableRect;
}

@end

@implementation FTExpandableView

@synthesize delegate;
@synthesize openRect;
@synthesize closedRect;
@synthesize openColor;
@synthesize closedColor;

- (id)initWithFrame:(CGRect)frame withContentFrame:(CGRect)contentFrame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        isClosed = true;
        closedRect = frame;
        openRect = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height+contentFrame.size.height);
        tappableRect= CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        closedColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1.0];
        openColor = [UIColor whiteColor];
        self.backgroundColor = closedColor;
        arrowDownImage = [UIImage imageNamed:@"arrow_down.png"];
        arrowUpImage = [UIImage imageNamed:@"arrow_up.png"];

        
        contentView = [[UIView alloc] initWithFrame:contentFrame];
        contentView.hidden = YES;
        [self addSubview:contentView];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [tapRecognizer setNumberOfTapsRequired:1];
        [self addGestureRecognizer:tapRecognizer];

        [self initMainButton];
        self.clipsToBounds = NO;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withContentFrame:(CGRect)contentFrame withOpenDirection:(float)openDirection {
    openDown = true;
    return [self initWithFrame:frame withContentFrame:contentFrame];
}


-(void)initMainButton {
    
    UIImage *dottedLine = [UIImage imageNamed:@"dotted_line.png"];
    UIImageView *dottedLineView = [[UIImageView alloc] initWithImage:dottedLine];
    if (openDown)
        dottedLineView.frame = CGRectMake(0, closedRect.size.height - 1, 320, 1);
    else
        dottedLineView.frame = CGRectMake(0, 0, 320, 1);
    
    float offset_x = 39;
    float offset_y = (closedRect.size.height - 21) / 2;
    mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(offset_x, offset_y, 100, 21)];
    mainLabel.textColor = [UIColor darkGrayColor];
    mainLabel.backgroundColor = [UIColor clearColor];
    mainLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:(17.0)];
    mainLabel.text = @"EXP VIEW";
    
    
    offset_x = 127;
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,offset_y, 276, 21)];
    textLabel.text = @"NONE";
    textLabel.textColor = [UIColor blackColor];
    textLabel.textAlignment = UITextAlignmentRight;
    textLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:17.0];
    textLabel.backgroundColor = [UIColor clearColor];

    arrowImage = [[UIImageView alloc] initWithFrame:CGRectMake(textLabel.frame.size.width+6, (closedRect.size.height-arrowUpImage.size.height)/2, arrowUpImage.size.width, arrowUpImage.size.height)];
    if (openDown)
        [arrowImage setImage:arrowDownImage];
    else
        [arrowImage setImage:arrowUpImage];
    
    [self addSubview:dottedLineView];
    [self addSubview:mainLabel];
    [self addSubview:textLabel];
    [self addSubview:arrowImage];

}

- (void)setLabel:(NSString*)label {
    mainLabel.text = label;
}

- (void)setText:(NSString*)text {
    textLabel.text = text;
}

- (void)setText:(NSString*)text withColor:(UIColor*)color {
    textLabel.text = text;
    textLabel.textColor = color;
}

-(void)handleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint p = [recognizer locationInView:self];
    if (CGRectContainsPoint(tappableRect, p)) {
        if (isClosed) {
            [self.delegate requestToOpenView:self];
        }
        else {
            [self.delegate requestToCloseView:self];
        }
    }

}

-(void)openView {
    isClosed = false;
    if (openDown)
        [arrowImage setImage:arrowUpImage];
    else
        [arrowImage setImage:arrowDownImage];
    self.frame = openRect;
    contentView.hidden = NO;
    self.backgroundColor = openColor;
    
}

-(void)closeView {
    isClosed = true;
    if (openDown)
        [arrowImage setImage:arrowDownImage];
    else
        [arrowImage setImage:arrowUpImage];

    self.frame = closedRect;
    contentView.hidden = YES;
    self.backgroundColor = closedColor;
}

-(void)requestToClose {
    if (isClosed==FALSE) {
        [self.delegate requestToCloseView:self];
    }
}





@end
