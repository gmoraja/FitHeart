//
//  FTOptionGroupView.m
//  FitHeart
//
//  Created by Bitgears on 06/12/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "FTOptionGroupView.h"
#import "UCFSUtil.h"

@interface FTOptionGroupView() {
    CGRect closedRect;
    CGRect openRect;
    NSArray *views;
    UIView *openView;
    UIView *pendingView;
    
    BOOL isAnimating;

}

@end



@implementation FTOptionGroupView

@synthesize delegate;
@synthesize slidableView;


- (id)initWithFrame:(CGRect)frame withViews:(NSArray*)allviews
{
    self = [super initWithFrame:frame];
    if (self) {
        openDown = FALSE;
        isAnimating = FALSE;
        //calcolate new frame
        views = allviews;
        if (views!=nil && [views count]>0) {
            float height = 0;
            for (int i=0; i<[views count]; i++) {
                UIView *view = [views objectAtIndex:i];
                height += view.frame.size.height;
            }

            float offset_y = self.frame.origin.y;
            /*
            if ((contHeight-offset_y-height)>0) {
                offset_y = contHeight-height;
            }
            */
            
            closedRect = CGRectMake(0, offset_y, 320, height);
            
            self.frame = closedRect;

        }
        
        self.backgroundColor = [UIColor whiteColor];
        openView = nil;
        
        float offset_y = 0;
        for (int i=0; i<[views count]; i++) {
            UIView *view = [views objectAtIndex:i];
            CGRect viewRect = CGRectMake(view.frame.origin.x, offset_y, view.frame.size.width, view.frame.size.height);
            view.frame = viewRect;
            offset_y = offset_y +  view.frame.size.height;
            [self addSubview:view];
        }
        
        self.clipsToBounds = YES;

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame withViews:(NSArray*)allviews withOpenDirection:(float)openDirection {
    
    self = [self initWithFrame:frame withViews:allviews];
    if (self) {
        openDown = true;
    }
    return self;
}


- (void)requestToCloseView:(UIView*)view {
    
    if (isAnimating==FALSE) {
        if (openView!=nil) {
            if (openView==view)
                openView = nil;
        }
        
        FTExpandableView *expView = (FTExpandableView*)view;
        
        
        int index = [self belowSelectedViewIndex:view];
        
        int diff = expView.openRect.size.height - expView.closedRect.size.height;
        float newOriginY = self.frame.origin.y+diff;
        if (openDown) {
            newOriginY = self.frame.origin.y;
        }
        CGRect newRect = CGRectMake(self.frame.origin.x, newOriginY, self.frame.size.width, self.frame.size.height-diff);
        [UIView animateWithDuration:0.5f animations:^{
            isAnimating = TRUE;
            self.frame = newRect;
            if ([views count]>1) {
                for (int i=(index+1); i<[views count]; i++) {
                    UIView *temp_view = [views objectAtIndex:i];
                    CGRect newTempRect = CGRectMake(temp_view.frame.origin.x, temp_view.frame.origin.y-diff, temp_view.frame.size.width, temp_view.frame.size.height);
                    temp_view.frame = newTempRect;
                }
            }
            if (slidableView!=nil) {
                CGRect slidableFrame = CGRectMake(slidableView.frame.origin.x, slidableView.frame.origin.y+diff, slidableView.frame.size.width, slidableView.frame.size.height);
                slidableView.frame = slidableFrame;
                
            }
            
        }completion:^(BOOL finished) {
            [expView closeView];
            [self.delegate collapsedView:view withOptionGroup:self];
            isAnimating = FALSE;
            if (pendingView!=nil) {
                [self requestToOpenView:pendingView];
                pendingView = nil;
            }
            if (openView==nil && slidableView!=nil) slidableView.userInteractionEnabled = TRUE;
        }];
        
        
    }

}

-(void)closeOpenedView {
    FTExpandableView *openedView = (FTExpandableView*)openView;
    [openedView closeView];
    /*
    int diff = openedView.openRect.size.height - openedView.closedRect.size.height;
    float newOriginY = self.frame.origin.y+diff;
    if (openDown) {
        newOriginY = self.frame.origin.y;
    }
    CGRect newRect = CGRectMake(self.frame.origin.x, newOriginY, self.frame.size.width, self.frame.size.height-diff);
    self.frame = newRect;
    CGRect newTempRect = CGRectMake(openView.frame.origin.x, openView.frame.origin.y+diff, openView.frame.size.width, openView.frame.size.height);
    openView.frame = newTempRect;
     */
}

-(void)close {
    if (openView!=nil) {
        FTExpandableView *openedView = (FTExpandableView*)openView;
        [self requestToCloseView:openedView];
    }
}


- (void)requestToOpenView:(UIView*)view {
    
    if (isAnimating==FALSE) {
        //check if another view is already open
        if (openView!=nil && openView!=view) {
            pendingView = view;
            //close the opened view and reserve pendingView
            [self requestToCloseView:openView];
        }
        else {
            
            FTExpandableView *expView = (FTExpandableView*)view;
            [expView openView];
            
            int index = [self belowSelectedViewIndex:view];
            
            int diff = expView.openRect.size.height - expView.closedRect.size.height;
            float newOriginY = self.frame.origin.y-diff;
            if (openDown) {
                newOriginY = self.frame.origin.y;
            }
            CGRect newRect = CGRectMake(self.frame.origin.x, newOriginY, self.frame.size.width, self.frame.size.height+diff);
            
            [UIView animateWithDuration:0.5f animations:^{
                isAnimating = TRUE;
                self.frame = newRect;
                if ([views count]>1) {
                    for (int i=(index+1); i<[views count]; i++) {
                        UIView *temp_view = [views objectAtIndex:i];
                        CGRect newTempRect = CGRectMake(temp_view.frame.origin.x, temp_view.frame.origin.y+diff, temp_view.frame.size.width, temp_view.frame.size.height);
                        temp_view.frame = newTempRect;
                    }
                }
                if (slidableView!=nil) {
                    CGRect slidableFrame = CGRectMake(slidableView.frame.origin.x, slidableView.frame.origin.y-diff, slidableView.frame.size.width, slidableView.frame.size.height);
                    slidableView.frame = slidableFrame;
                }
                
            }completion:^(BOOL finished) {
                [self.delegate expandedView:view withOptionGroup:self];
                openView = view;
                isAnimating = FALSE;
                if (openView!=nil && slidableView!=nil) slidableView.userInteractionEnabled = FALSE;
            }];
            
            
        }
        
    }
    


}

-(int)belowSelectedViewIndex:(UIView*)view {
    int index = 0;
    if ([views count]>1) {
        for (int i=0; i<[views count]; i++) {
            UIView *temp_view = [views objectAtIndex:i];
            if (view==temp_view) {
                index = i;
                break;
            }
        }
    }
    return index;
}

- (void)valueChanged:(int)value {
    if ( [self.delegate respondsToSelector:@selector(valueChanged)] ) {
        [self.delegate valueChanged];
    }
}




@end

