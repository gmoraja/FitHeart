//
//  FTDialogView.h
//  FitHeart
//
//  Created by Bitgears on 04/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FTDialogDelegate
- (void)dialogPopupFinished:(UIView*)dialogView;
@end

@interface FTDialogView : UIView {
    
}

@property (weak) id <FTDialogDelegate> delegate;

- (id)initFullscreen;
- (id)initFullscreenWithImage:(UIImage*)image;
- (id)initFullscreenWithImage:(UIImage*)image withText:(NSString*)text;
- (void)popupText:(NSString*)text;

@end
