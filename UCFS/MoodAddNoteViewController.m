//
//  MoodAddNoteViewController.m
//  FitHeart
//
//  Created by Bitgears on 23/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "MoodAddNoteViewController.h"
#import "MoodSection.h"
#import "UCFSUtil.h"
#import "MMDrawerController.h"
#import "MMDrawerBarButtonItem.h"
#import "UIViewController+MMDrawerController.h"
#import "FTDialogView.h"
#import "FTNoteData.h"
#import "FTSimplePleasureSelectView.h"
#import "FTOptionGroupView.h"

static NSString* placeholder = @"Tap to enter text...";
static float simplePleasureTextMarginLeft = 37;
static float simplePleasureTextMarginRight = 30;

@interface MoodAddNoteViewController () {
    
    FTSimplePleasureSelectView* spSelectView;
    FTOptionGroupView* optionView;
    UILabel* simplePleasureLabel;
    float noteTextViewY;
    UIColor* placeHolderColor;
    float textEditHeight;
}

@end

@implementation MoodAddNoteViewController

@synthesize noteTextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSimplePleasure:(bool)sp
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isEdit = FALSE;
        note = nil;
        isSimplePleasure = sp;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withSimplePleasure:(bool)sp withNote:(FTNoteData*)noteData
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        isEdit = TRUE;
        note = noteData;
        isSimplePleasure = sp;
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSString* title = nil;
    if (isSimplePleasure) {
        if (isEdit)
            title = @"EDIT ENTRY";
        else
            title = @"ADD ENTRY";
    }
    else {
        if (isEdit)
            title = @"EDIT NOTE";
        else
            title = @"ADD NOTE";
    }
    
    self.wantsFullScreenLayout = YES;
    [UCFSUtil initNavigationBar:self.navigationController.navigationBar
                           item:self.navigationItem
                          title:title
                    bkgFileName:[MoodSection navBarBkg:-1]
                      tintColor:[MoodSection mainColor:-1]
                 isBackVisibile: YES
     ];
    
    [self setupLeftMenuButton];
    [self setupRightMenuButton];
    
    placeHolderColor = [UIColor colorWithRed:209.0/255.0 green:201.0/255.0 blue:186.0/255.0 alpha:1];
    
    noteTextView.delegate = self;
    if (isEdit) {
        noteTextView.text = note.note;
    }
    else {
        noteTextView.text = placeholder;
        noteTextView.textColor = placeHolderColor;
    }
    
    
    if (isSimplePleasure) {
        CGRect spSelectRect = CGRectMake(0, 0, 320, 50);
        spSelectView = [[FTSimplePleasureSelectView alloc] initWithFrame:spSelectRect
                                                             withSection:[MoodSection class]
                                                                withFont:@"Futura-CondensedMedium"
                                                            withFontSize:18.0
                        ];
        
        NSArray *allviews = [[NSArray alloc] initWithObjects:spSelectView, nil];
        float pos = 40;
        if ([UCFSUtil deviceSystemIOS7]) pos = 0;
        optionView = [[FTOptionGroupView alloc] initWithFrame:CGRectMake(0, pos, 320, 100)
                                                    withViews:allviews
                                                    withOpenDirection:0
                      ];
        if (isEdit)
            [spSelectView updateValue:note.simplePleasure];
        else
            [spSelectView updateValue:2];
        spSelectView.delegate = optionView;
        optionView.delegate = self;
        
        CGRect simplePleasureLabelRect = CGRectMake(simplePleasureTextMarginLeft, optionView.frame.origin.y+optionView.frame.size.height+20, 320-(simplePleasureTextMarginLeft+simplePleasureTextMarginRight), 80);
        simplePleasureLabel = [[UILabel alloc] initWithFrame:simplePleasureLabelRect];
        simplePleasureLabel.lineBreakMode = UILineBreakModeWordWrap;
        simplePleasureLabel.numberOfLines = 0;
        simplePleasureLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:(14.0)];
        simplePleasureLabel.textColor = [UIColor grayColor];
        simplePleasureLabel.backgroundColor = [UIColor clearColor];
        simplePleasureLabel.userInteractionEnabled=TRUE;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSimplePleasuresLabelTap:)];
        [tapRecognizer setNumberOfTapsRequired:1];
        [simplePleasureLabel addGestureRecognizer:tapRecognizer];
        [self valueChanged];

        
        [self.view addSubview:simplePleasureLabel];
        [self.view addSubview:optionView];
    }
    


}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (isEdit==FALSE && isSimplePleasure==FALSE)
        [noteTextView becomeFirstResponder];
    
    float marginBottom = 20;
    if ([UCFSUtil deviceSystemIOS7]) marginBottom = 20;
    
    textEditHeight = [UCFSUtil contentAreaHeight]-20-216-marginBottom; //20=margin-top, 216= keypad height, 10=bottom margin
    if (isSimplePleasure)
        textEditHeight = textEditHeight - optionView.frame.size.height;
    noteTextView.frame = CGRectMake(noteTextView.frame.origin.x, noteTextView.frame.origin.y, noteTextView.frame.size.width, textEditHeight);
    
}

-(void)setupLeftMenuButton{
    self.navigationItem.leftBarButtonItem = [UCFSUtil getNavigationBarCancelButtonWithTarget:self action:@selector(cancelAction:)];
}

-(void)setupRightMenuButton{
    self.navigationItem.rightBarButtonItem = [UCFSUtil getNavigationBarSaveButtonWithTarget:self action:@selector(saveAction:)];
}

- (IBAction)cancelAction:(UIButton*)sender {
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{

    if ([textView.text isEqualToString:placeholder]) {
         textView.text = @"";
         textView.textColor = [UIColor blackColor];
    }
    if (isSimplePleasure && spSelectView!=nil) {
        [spSelectView requestToClose];
    }
    [textView becomeFirstResponder];
    if (isSimplePleasure)
        [self animateTextField:textView up: YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    if ([textView.text isEqualToString:@""]) {
        textView.text = placeholder;
        textView.textColor = placeHolderColor;
    }
    [textView resignFirstResponder];
    if (isSimplePleasure)
        [self animateTextField:textView up: NO];
}

- (void)textViewDidChange:(UITextView *)textView {
    //FIX IOS 7 BUG LAST ROW
    
    CGRect line = [textView caretRectForPosition:
                   textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height
    - ( textView.contentOffset.y + textView.bounds.size.height
       - textView.contentInset.bottom - textView.contentInset.top );
    if ( overflow > 0 ) {
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [UIView animateWithDuration:.2 animations:^{
            [textView setContentOffset:offset];
        }];
    }

}

- (void) animateTextField:(UITextView*) textField up: (BOOL) up
{
    const float movementDistance = noteTextViewY; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    textField.frame = CGRectOffset(textField.frame, 0, movement);
    simplePleasureLabel.frame = CGRectOffset(simplePleasureLabel.frame, 0, movement);
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if ([noteTextView isFirstResponder] && [touch view] != noteTextView) {
        [noteTextView resignFirstResponder];
    }
    [super touchesBegan:touches withEvent:event];
}

- (IBAction)saveAction:(UIButton*)sender {
    //show loading
    /*
    FTDialogView *dialogView = [[FTDialogView alloc] initFullscreen];
    dialogView.delegate = self;
    [self.parentViewController.view addSubview:dialogView];
     */
    //save data
    if (isEdit) {
        note.note = noteTextView.text;
        note.simplePleasure = [spSelectView getValue];
        [MoodSection editNote:note];
    }
    else {
        FTNoteData* noteData = nil;
        if (isSimplePleasure)
            noteData = [FTNoteData initAsSimplePleasureWithType:[spSelectView getValue] withText:noteTextView.text ];
        else
            noteData = [FTNoteData initAsNoteWithText:noteTextView.text ];
        [MoodSection saveNote:noteData];
    }
    //[dialogView popupText:@"Successfully Saved"];
    [self cancelAction:nil];

}

- (void)dialogPopupFinished:(UIView*)dialogView {
    //hide loading
    [dialogView removeFromSuperview];
    [self cancelAction:nil];

}

- (void)expandedView:(UIView*)view withOptionGroup:(UIView*)optionGroupView {
    CGRect simplePleasureLabelRect = CGRectMake(simplePleasureLabel.frame.origin.x, optionView.frame.origin.y+optionView.frame.size.height+20, simplePleasureLabel.frame.size.width, simplePleasureLabel.frame.size.height);
    simplePleasureLabel.frame = simplePleasureLabelRect;
    
    CGRect noteTextViewRect = CGRectMake(simplePleasureLabel.frame.origin.x, simplePleasureLabel.frame.origin.y+simplePleasureLabel.frame.size.height+15, simplePleasureLabel.frame.size.width, textEditHeight);
    noteTextView.frame = noteTextViewRect;
    
}

- (void)collapsedView:(UIView*)view withOptionGroup:(UIView*)optionGroupView {
    CGRect simplePleasureLabelRect = CGRectMake(simplePleasureLabel.frame.origin.x, optionView.frame.origin.y+optionView.frame.size.height+20, simplePleasureLabel.frame.size.width, simplePleasureLabel.frame.size.height);
    simplePleasureLabel.frame = simplePleasureLabelRect;
    
    CGRect noteTextViewRect = CGRectMake(simplePleasureLabel.frame.origin.x, simplePleasureLabel.frame.origin.y+simplePleasureLabel.frame.size.height+15, simplePleasureLabel.frame.size.width, textEditHeight);
    noteTextView.frame = noteTextViewRect;
}

- (void)valueChanged {
    simplePleasureLabel.text = [MoodSection simplePleasureTextPrompt:[spSelectView getValue]];
    [simplePleasureLabel sizeToFit];
    CGRect newFrame = simplePleasureLabel.frame;
    newFrame.size.width = 320-(simplePleasureTextMarginLeft+simplePleasureTextMarginRight);
    simplePleasureLabel.frame = newFrame;
    CGRect noteTextViewRect = CGRectMake(simplePleasureLabel.frame.origin.x-5, simplePleasureLabel.frame.origin.y+simplePleasureLabel.frame.size.height+15, simplePleasureLabel.frame.size.width, textEditHeight);
    noteTextView.frame = noteTextViewRect;
    noteTextViewY = simplePleasureLabel.frame.size.height+20;
    
}

-(void)handleSimplePleasuresLabelTap:(UITapGestureRecognizer *)recognizer {
    [noteTextView becomeFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
