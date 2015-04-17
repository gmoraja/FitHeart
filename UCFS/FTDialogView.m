//
//  FTDialogView.m
//  FitHeart
//
//  Created by Bitgears on 04/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#ifdef __IPHONE_6_0
# define ALIGN_CENTER NSTextAlignmentCenter
#else
# define ALIGN_CENTER UITextAlignmentCenter
#endif

#import "FTDialogView.h"
#import "UCFSUtil.h"

@implementation FTDialogView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initFullscreen {
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height);
    
    if ([UCFSUtil deviceSystemIOS7])
        frame.origin.y = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.6;
    }
    return self;
}

- (id)initFullscreenWithImage:(UIImage*)image {
    self = [self initFullscreen];
    if (self) {
        self.alpha = 1;
        CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height);
        UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = frame;
        imageView.userInteractionEnabled = YES;
      
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [tapRecognizer setNumberOfTapsRequired:1];
        [imageView addGestureRecognizer:tapRecognizer];
        
        [self addSubview:imageView];
    }
    return self;

}

- (id)initFullscreenWithImage:(UIImage*)image withText:(NSString*)text {
    self = [self initFullscreenWithImage:image];
    if (self) {
        CGRect frame = CGRectMake(20, [[UIScreen mainScreen] applicationFrame].size.height-80, 280, 80);
        UILabel* labelView = [[UILabel alloc] initWithFrame:frame];
        labelView.textColor = [UIColor whiteColor];
        labelView.backgroundColor = [UIColor clearColor];
        labelView.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18.0];
        labelView.textAlignment =  ALIGN_CENTER;
        labelView.numberOfLines = 0;
        labelView.lineBreakMode = NSLineBreakByWordWrapping;
        labelView.text = text;
        [self addSubview:labelView];
    }
    return self;
    
}


-(void)popupText:(NSString*)text {
    
 
    float offset_y = (self.frame.size.height - 100) / 2;
    UILabel *mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, offset_y, 320, 100)];
    mainLabel.textColor = [UIColor whiteColor];
    mainLabel.backgroundColor = [UIColor clearColor];
    mainLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:18.0];
    mainLabel.text = text;
    mainLabel.textAlignment =  ALIGN_CENTER;
    mainLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:mainLabel];
    
    mainLabel.alpha = 1.0f;
    // Then fades it away after 2 seconds (the cross-fade animation will take 0.5s)
    [UIView animateWithDuration:0.5 delay:2.0 options:0 animations:^{
        // Animate the alpha value of your imageView from 1.0 to 0.0 here
        mainLabel.alpha = 0.0f;
    } completion:^(BOOL finished) {
        // Once the animation is completed and the alpha has gone to 0.0, hide the view for good
        mainLabel.hidden = YES;
        [delegate dialogPopupFinished:self];
    }];
}

-(void)handleTap:(UITapGestureRecognizer *)recognizer {
    if (delegate!=nil)
        [delegate dialogPopupFinished:self];
}



@end
