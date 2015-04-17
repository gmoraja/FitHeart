//
//  MoodSimplePleasuresViewController.h
//  FitHeart
//
//  Created by Bitgears on 23/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoodNoteView.h"
#import "FTNoteHeaderView.h"
#import "FTDialogView.h"

@interface MoodSimplePleasuresViewController : UIViewController<MoodNoteDelegate, FTNoteHeaderDelegate, FTDialogDelegate, UITableViewDataSource,UITableViewDelegate> {
    

}




@property (strong, nonatomic) IBOutlet UILabel *firstUseLabel;
@property (strong, nonatomic) IBOutlet UITableView *noteTableView;

@end
