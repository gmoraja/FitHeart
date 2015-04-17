//
//  AFPickerView.m
//  PickerView
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


#import "AFPickerView.h"


@implementation AFPickerView

#pragma mark - Synthesization

@synthesize dataSource;
@synthesize delegate;
@synthesize selectedRow = currentRow;
@synthesize rowFont = _rowFont;
@synthesize rowIndent;
@synthesize backgroundImageName;
@synthesize glassImageName;
@synthesize shadowsImageName;
@synthesize textColor;
@synthesize selectedtextColor;
@synthesize rowHeight;
@synthesize alignment;
@synthesize visibleRange;




#pragma mark - Custom getters/setters

- (void)setSelectedRow:(NSInteger)selectedRow
{
    if (selectedRow >= rowsCount)
        return;
    
    currentRow = selectedRow;
    [contentView setContentOffset:CGPointMake(0.0, rowHeight * currentRow  ) animated:NO];
    //[self tileViews];
    [self setVisibleRowColors];
}




- (void)setRowFont:(UIFont *)rowFont
{
    _rowFont = rowFont;
    
    for (UILabel *aLabel in visibleViews) 
    {
        aLabel.font = _rowFont;
    }
    
    for (UILabel *aLabel in recycledViews) 
    {
        aLabel.font = _rowFont;
    }
}




- (void)setRowIndent:(CGFloat)indent
{
    rowIndent = indent;
    
    for (UILabel *aLabel in visibleViews) 
    {
        CGRect frame = aLabel.frame;
        if (alignment==0)
            frame.origin.x = rowIndent;
        frame.size.width = self.frame.size.width - rowIndent;
        aLabel.frame = frame;
    }
    
    for (UILabel *aLabel in recycledViews) 
    {
        CGRect frame = aLabel.frame;
        if (alignment==0)
            frame.origin.x = rowIndent;
        frame.size.width = self.frame.size.width - rowIndent;
        aLabel.frame = frame;
    }
}




#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame withRowHeight:(CGFloat)rowheight withBackground:(NSString*)bkgImage withShadow:(NSString*)shadowImage;
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // setup
        _rowFont = [UIFont boldSystemFontOfSize:28.0];
        rowIndent = 10.0;
        currentRow = 0;
        rowsCount = 0;
        rowHeight = rowheight;
        visibleViews = [[NSMutableSet alloc] init];
        recycledViews = [[NSMutableSet alloc] init];
        visibleRange = 3;

        
        // content
        contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, frame.size.height)];
        contentView.showsHorizontalScrollIndicator = NO;
        contentView.showsVerticalScrollIndicator = NO;
        contentView.delegate = self;
        contentView.bounces =NO;
        //contentView.backgroundColor = [UIColor redColor];
        [self addSubview:contentView];
        
        //ACCESSIBILITY
        if (UIAccessibilityIsVoiceOverRunning()) {
            
            self.accessibilityTraits = UIAccessibilityTraitAdjustable;
            
            [self setIsAccessibilityElement:YES];
            self.userInteractionEnabled = YES;
        }
        else {
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
            [self addGestureRecognizer:tapRecognizer];
        }

        
        // shadows
        if (shadowImage!=nil) {
            shadowsImageName = shadowImage;
            UIImageView *shadows = [[UIImageView alloc] initWithImage:[UIImage imageNamed:shadowsImageName]];
            [self addSubview:shadows];
        }

        
        // glass
        if (glassImageName!=nil) {
            UIImage *glassImage = [UIImage imageNamed:glassImageName];
            glassImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 76.0, glassImage.size.width, glassImage.size.height)];
            glassImageView.image = glassImage;
            [self addSubview:glassImageView];
        }
        


    }
    return self;
}




#pragma mark - Buisness

- (void)reloadData
{
    // empry views
    currentRow = 0;
    rowsCount = 0;
    
    for (UIView *aView in visibleViews) 
        [aView removeFromSuperview];
    
    for (UIView *aView in recycledViews)
        [aView removeFromSuperview];
    
    visibleViews = [[NSMutableSet alloc] init];
    recycledViews = [[NSMutableSet alloc] init];
    
    rowsCount = [dataSource numberOfRowsInPickerView:self];
    [contentView setContentOffset:CGPointMake(0.0, 0.0) animated:NO];
    //float contentHeight = (rowHeight * rowsCount);
    CGFloat contentHeight = (rowHeight * rowsCount) + (visibleRange*2+1) * rowHeight;
     contentView.contentSize = CGSizeMake(contentView.frame.size.width, contentHeight);
    [self tileViews];
    [self setVisibleRowColors];
}


- (void)setVisibleRowColors {
    NSString *text = [dataSource pickerView:self titleForRow:currentRow];
    for (UIView *aView in visibleViews) {
        UILabel *label = ((UILabel*)aView);
        
        if ([label.text isEqualToString:text]  ) {
            label.textColor = self.selectedtextColor;
        }
        else {
            label.textColor = self.textColor;//[UIColor blackColor];//;
            
        }
        
    }
}

- (void)determineCurrentRow
{
    CGFloat delta = contentView.contentOffset.y;
    NSLog(@"delta %f", delta);
    int position = round(delta / rowHeight);
    NSLog(@"position %i", position);
    currentRow = position;
    if (currentRow>=rowsCount) {
        currentRow = rowsCount -1;
        position = currentRow;
    }
    //NSLog(@"currentRow %i", currentRow);
    
    //NSLog(@"offset %f", rowHeight * (currentRow - (visibleRange-2) ));
    CGFloat offset = rowHeight * currentRow;
    NSLog(@"offset %f", offset);
    [contentView setContentOffset:CGPointMake(0.0, offset ) animated:YES];

    [delegate pickerView:self didSelectRow:position];

    [self setVisibleRowColors];

}




- (void)didTap:(id)sender
{

    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
    CGPoint point = [tapRecognizer locationInView:self];
    int steps = floor(point.y / rowHeight) - visibleRange;
    [self makeSteps:steps];


}


- (void)didSwipe:(id)sender
{
    if (UIAccessibilityIsVoiceOverRunning()) {
        UISwipeGestureRecognizer* recognizer = (UISwipeGestureRecognizer*)sender;
        if (recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
            if (currentRow<(rowsCount-1))
                [self makeSteps:1];
            
        }
        else {
            if (currentRow>0)
                [self makeSteps:-1];
            
        }
    }
}




- (void)makeSteps:(int)steps
{
    //if (steps == 0 || steps > 2 || steps < -2)
    if (steps == 0 )
        return;
    
    [contentView setContentOffset:CGPointMake(0.0, rowHeight * currentRow ) animated:NO];
    
    int newRow = (int)currentRow + steps;
    if (newRow < 0 || newRow >= rowsCount)
    {
        if (steps == -2)
            [self makeSteps:-1];
        else if (steps == 2)
            [self makeSteps:1];
        /*
        if (steps == -2)
            [self makeSteps:-1];
        else if (steps == 2)
            [self makeSteps:1];
         */
        
        return;
    }
    
    currentRow = currentRow + steps;
    if (currentRow<rowsCount) {
        [contentView setContentOffset:CGPointMake(0.0, rowHeight * currentRow ) animated:YES];
        [delegate pickerView:self didSelectRow:currentRow];
        [self setVisibleRowColors];
        
    }
 
}




#pragma mark - recycle queue

- (UIView *)dequeueRecycledView
{
	UIView *aView = [recycledViews anyObject];
	
    if (aView) 
        [recycledViews removeObject:aView];
    return aView;
}



- (BOOL)isDisplayingViewForIndex:(NSUInteger)index
{
	BOOL foundPage = NO;
    for (UIView *aView in visibleViews) 
	{
        int viewIndex = aView.frame.origin.y / rowHeight - visibleRange;
        if (viewIndex == index) 
		{
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}




- (void)tileViews
{
    // Calculate which pages are visible
    CGRect visibleBounds = contentView.bounds;
    int firstNeededViewIndex = floorf(CGRectGetMinY(visibleBounds) / rowHeight) - visibleRange;
    int lastNeededViewIndex  = floorf((CGRectGetMaxY(visibleBounds) / rowHeight)) - visibleRange;
    firstNeededViewIndex = MAX(firstNeededViewIndex, 0);
    lastNeededViewIndex  = MIN(lastNeededViewIndex, (int)rowsCount - 1);
	
    // Recycle no-longer-visible pages 
	for (UIView *aView in visibleViews) 
    {
        int viewIndex = aView.frame.origin.y / rowHeight - visibleRange;
        if (viewIndex < firstNeededViewIndex || viewIndex > lastNeededViewIndex) 
        {
            [recycledViews addObject:aView];
            [aView removeFromSuperview];
        }
    }
    
    [visibleViews minusSet:recycledViews];
    
    // add missing pages
	for (int index = firstNeededViewIndex; index <= lastNeededViewIndex; index++) 
	{
        if (![self isDisplayingViewForIndex:index]) 
		{
            UILabel *label = (UILabel *)[self dequeueRecycledView];
            
			if (label == nil)
            {
                if (alignment==0)
                    label = [[UILabel alloc] initWithFrame:CGRectMake(rowIndent, 0, self.frame.size.width - rowIndent, rowHeight)];
                else
                    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width - rowIndent, rowHeight)];
                label.backgroundColor = [UIColor clearColor];
                label.textColor = self.textColor;
                label.font = self.rowFont;
                //label.textColor = RGBACOLOR(255.0, 255.0, 255.0, 0.71);
                
            }
            label.textColor = self.textColor;
            
            [self configureView:label atIndex:index];
            [contentView addSubview:label];
            [visibleViews addObject:label];
        }
    }
    

}




- (void)configureView:(UIView *)view atIndex:(NSUInteger)index
{
    @try {
        UILabel *label = (UILabel *)view;
        if (dataSource!=nil)
            label.text = [dataSource pickerView:self titleForRow:index];
        switch(alignment) {
            case 0: label.textAlignment =  ALIGN_LEFT; break;
            case 1: label.textAlignment =  ALIGN_CENTER; break;
            case 2: label.textAlignment =  ALIGN_RIGHT; break;
        }
        
        CGRect frame = label.frame;
        //frame.origin.y = rowHeight * index + (rowHeight*2);
        frame.origin.y = rowHeight * (index+visibleRange);
        label.frame = frame;
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    


}




#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tileViews];
}




- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
        [self determineCurrentRow];
}




- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self determineCurrentRow];
}



-(void)accessibilityIncrement {
    if (currentRow>0)
        [self makeSteps:-1];

}
-(void)accessibilityDecrement {
    if (currentRow<(rowsCount-1))
        [self makeSteps:1];
}






@end
