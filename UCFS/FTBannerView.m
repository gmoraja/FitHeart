//
//  FTBannerView.m
//  FitHeart
//
//  Created by Bitgears on 20/01/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "FTBannerView.h"


static float MESSAGE_MARGIN_X = 15;
static float MESSAGE_MARGIN_Y = 9;
static float MESSAGE_WIDTH = 250;
static float MESSAGE_LINE_SPACING = 0;

@interface FTBannerView() {
    float marginY;
}

@end

@implementation FTBannerView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame withSection:(Class<FTSection>)section {
    self = [super initWithFrame:frame];
    if (self) {
        currentSection = section;
        
        marginY = MESSAGE_MARGIN_Y;
        if (frame.size.height<55) marginY = 5; //fix for health

        self.backgroundColor = [UIColor whiteColor];

        UIImage *reloadImage = [UIImage imageNamed:[currentSection bannerReloadImageFilename]];
        float x_center = frame.size.width - reloadImage.size.width - 5;
        float y_center = (frame.size.height - reloadImage.size.height) / 2;
        reloadButton = [[UIButton alloc] initWithFrame:CGRectMake(x_center,y_center, reloadImage.size.width, reloadImage.size.height)];
        [reloadButton setBackgroundImage:reloadImage forState:UIControlStateNormal];
        [reloadButton addTarget:self action:@selector(reloadButtonTouch:) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect scrollRect = CGRectMake(MESSAGE_MARGIN_X, marginY, MESSAGE_WIDTH, frame.size.height-(marginY*2) );
        scrollView = [[UIScrollView alloc]initWithFrame:scrollRect];
        scrollView.showsVerticalScrollIndicator=YES;
        scrollView.scrollEnabled=YES;
        scrollView.userInteractionEnabled=YES;
        
        scrollView.bounces = FALSE;
        
        CGRect messageRect = CGRectMake(0, 0, MESSAGE_WIDTH, frame.size.height-(marginY*2) );
        messageLabel = [[RTLabel alloc] initWithFrame:messageRect];
        messageLabel.font = [UIFont fontWithName:@"Futura-CondensedMedium" size:(16.0)];
        messageLabel.textColor = [UIColor colorWithRed:106.0/255.0 green:106.0/255.0 blue:106.0/255.0 alpha:1];
        messageLabel.lineSpacing = MESSAGE_LINE_SPACING;
        messageLabel.text = @"";

        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [tapRecognizer setNumberOfTapsRequired:1];
        [messageLabel addGestureRecognizer:tapRecognizer];
        
        
        [scrollView addSubview:messageLabel];
        
        [self addSubview:scrollView];
        [self addSubview:reloadButton];
        
    }
    return self;
}


- (void)updateWithNotification:(FTNotification*)notification {
    currentNotification = notification;
    messageLabel.text = notification.message;
    CGSize newSize = [messageLabel optimumSize];
    CGRect messageRect;
    float maxVSpace = self.frame.size.height-(MESSAGE_MARGIN_Y*2);
    if (newSize.height<maxVSpace ) {
        messageRect = CGRectMake(messageLabel.frame.origin.x, (maxVSpace-newSize.height) / 2, messageLabel.frame.size.width, newSize.height );
    }
    else
        messageRect = CGRectMake(messageLabel.frame.origin.x, 0, messageLabel.frame.size.width, newSize.height );
    
    messageLabel.frame = messageRect;
    [scrollView setContentSize:newSize];
    [scrollView setContentOffset:CGPointZero animated:NO];
    [scrollView layoutIfNeeded];
}

- (IBAction)reloadButtonTouch:(UIButton*)sender {
    if (delegate!=nil)
        [self.delegate notificationReload];
}

-(void)handleTap:(UITapGestureRecognizer *)recognizer {
    if (currentNotification!=nil && currentNotification.action!=nil) {
        if (delegate!=nil)
            [self.delegate notificationAction:currentNotification];
    }
}


@end
