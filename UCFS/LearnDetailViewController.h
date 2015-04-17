//
//  LearnDetailViewController.h
//  FitHeart
//
//  Created by Bitgears on 29/12/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
#import "FTNote.h"

@interface LearnDetailViewController : GAITrackedViewController<UIWebViewDelegate> {
    
}

@property (strong, nonatomic) IBOutlet UIWebView *detailWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withNote:(FTNote*)note withSectionName:(NSString*)sectionName ;

@end
