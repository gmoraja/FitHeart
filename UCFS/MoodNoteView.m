//
//  MoodNoteView.m
//  FitHeart
//
//  Created by Bitgears on 22/12/13.
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

#import "MoodNoteView.h"
#import "MoodSection.h"
#import "MoodNoteLabelView.h"

static  float deleteContentWidth = 100;

@interface MoodNoteView() {

    UIView* containerView;
    UIView* contentView;
    UIView* deleteView;
    UIButton* deleteButton;
    
    bool deleteViewIsHidden;


}

@end

@implementation MoodNoteView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame withNote:(FTNoteData*)noteData
{

    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        note = noteData;
        deleteViewIsHidden = TRUE;
        
        CGRect mainFrame = CGRectMake(0, 0, self.frame.size.width+deleteContentWidth, self.frame.size.height);
        containerView = [[UIView alloc] initWithFrame:mainFrame];

        [self initDelete];
        [self initContent];
        
        UIImageView *aLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height-1, frame.size.width, 1)];
        [aLine setImage:[UIImage imageNamed:@"dotted_line"]];
        
        [self addSubview:containerView];
        [self addSubview:aLine];
        
    }
    return self;
}

-(void)initDelete {
    CGRect deleteFrame = CGRectMake(self.frame.size.width, 0, deleteContentWidth, self.frame.size.height);
    deleteView = [[UIView alloc] initWithFrame:deleteFrame];
    deleteView.backgroundColor = [UIColor colorWithRed:232.0/255.0 green:209.0/255.0 blue:159.0/255.0 alpha:1.0];
    
    UIImage *deleteImage = [UIImage imageNamed:@"mood_delete_btn"];
    float x_center = (deleteFrame.size.width - deleteImage.size.width) / 2;
    float y_center = (deleteFrame.size.height - deleteImage.size.height) / 2;
    deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(x_center,y_center, deleteImage.size.width, deleteImage.size.height)];
    [deleteButton setBackgroundImage:deleteImage forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [deleteView addSubview:deleteButton];
    
    [containerView addSubview:deleteView];
    
}


-(void)initContent {
    
    CGRect contentFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    contentView = [[UIView alloc] initWithFrame:contentFrame];
    //contentView.backgroundColor = [UIColor redColor];
    
    //DATE
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE MM/dd/yyyy"];
    float topMargin = 17;
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, topMargin, 280, 20)];
    dateLabel.textColor = [MoodSection mainColor:-1];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.font = [UIFont fontWithName:@"Futura-CondensedMedium" size:(17.0)];
    dateLabel.text = [dateFormatter stringFromDate:note.insertDate];
    dateLabel.textAlignment =  ALIGN_LEFT;
    dateLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    //TEXT
    topMargin = dateLabel.frame.origin.y + dateLabel.frame.size.height + 4;
    textLabel = [[MoodNoteLabelView alloc] initWithFrame:CGRectMake(20, topMargin, 280, 50)];
    textLabel.textColor = [UIColor blackColor];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont fontWithName:@"Helvetica" size:(14.0)];
    textLabel.text = note.note;
    textLabel.textAlignment =  ALIGN_LEFT;
    textLabel.numberOfLines = 0;
    textLabel.lineBreakMode = UILineBreakModeWordWrap;

    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleFingerTap.cancelsTouchesInView = NO;
    [containerView addGestureRecognizer:singleFingerTap];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    swipeLeft.cancelsTouchesInView = NO;
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [containerView addGestureRecognizer:swipeLeft];

    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    swipeRight.cancelsTouchesInView = NO;
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [containerView addGestureRecognizer:swipeRight];
    
    [contentView addSubview:dateLabel];
    [contentView addSubview:textLabel];
    contentView.clipsToBounds = YES;
    
    [containerView addSubview:contentView];


}

- (void)updateWithNote:(FTNoteData*)noteData {
    note = noteData;
    textLabel.text = note.note;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE MM/dd/yyyy"];
    
    dateLabel.text = [dateFormatter stringFromDate:note.insertDate];
}


-(IBAction)deleteAction:(id)sender {
    [self.delegate deleteNote:note withView:self];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:containerView];
    if (location.x>=0 && location.x<=(containerView.frame.size.width-deleteContentWidth))
        [self.delegate editNote:note withView:self];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    if([recognizer direction] == UISwipeGestureRecognizerDirectionRight) {
        if (deleteViewIsHidden==FALSE)
            [self closeDelete];
    }else{
        if (deleteViewIsHidden==TRUE)
            [self openDelete];
    }
}

-(void)openDelete {
    deleteViewIsHidden = FALSE;
    [UIView animateWithDuration:0.5f animations:^{
        CGRect newTempRect = CGRectMake(containerView.frame.origin.x-deleteContentWidth, containerView.frame.origin.y, containerView.frame.size.width, containerView.frame.size.height);
        containerView.frame = newTempRect;
        
    }completion:^(BOOL finished) {
        
    }];
}

-(void)closeDelete {
    deleteViewIsHidden = TRUE;
    [UIView animateWithDuration:0.5f animations:^{
        CGRect newTempRect = CGRectMake(containerView.frame.origin.x+deleteContentWidth, containerView.frame.origin.y, containerView.frame.size.width, containerView.frame.size.height);
        containerView.frame = newTempRect;
        
    }completion:^(BOOL finished) {
    }];
}


@end
