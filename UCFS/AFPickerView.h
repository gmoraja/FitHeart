//
//  AFPickerView.h
//  PickerView
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@protocol AFPickerViewDataSource;
@protocol AFPickerViewDelegate;

@interface AFPickerView : UIView <UIScrollViewDelegate>
{
    __unsafe_unretained id <AFPickerViewDataSource> dataSource;
    __unsafe_unretained id <AFPickerViewDelegate> delegate;
    UIScrollView *contentView;
    UIImageView *glassImageView;
    
    NSInteger currentRow;
    NSInteger rowsCount;
    CGFloat rowHeight;
    
    CGPoint previousOffset;
    BOOL isScrollingUp;
    
    // recycling
    NSMutableSet *recycledViews;
    NSMutableSet *visibleViews;
    
    UIFont *_rowFont;

    
    NSString *backgroundImageName;
    NSString *shadowsImageName;
    NSString *glassImageName;
    UIColor *textColor;
    UIColor *selectedtextColor;
    
    int alignment;
    int visibleRange;
}

@property (nonatomic, unsafe_unretained) id <AFPickerViewDataSource> dataSource;
@property (nonatomic, unsafe_unretained) id <AFPickerViewDelegate> delegate;
@property (nonatomic, unsafe_unretained) NSInteger selectedRow;
@property (nonatomic, strong) UIFont *rowFont;
@property (nonatomic, unsafe_unretained) CGFloat rowIndent;
@property (nonatomic, strong) NSString *backgroundImageName;
@property (nonatomic, strong) NSString *shadowsImageName;
@property (nonatomic, strong) NSString *glassImageName;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *selectedtextColor;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) int alignment;
@property (nonatomic, assign) int visibleRange;

- (id)initWithFrame:(CGRect)frame withRowHeight:(CGFloat)rowheight withBackground:(NSString*)bkgImage withShadow:(NSString*)shadowImage;


- (void)reloadData;
- (void)determineCurrentRow;
- (void)didTap:(id)sender;
- (void)makeSteps:(int)steps;

// recycle queue
- (UIView *)dequeueRecycledView;
- (BOOL)isDisplayingViewForIndex:(NSUInteger)index;
- (void)tileViews;
- (void)configureView:(UIView *)view atIndex:(NSUInteger)index;

@end



@protocol AFPickerViewDataSource <NSObject>

- (NSInteger)numberOfRowsInPickerView:(AFPickerView *)pickerView;
- (NSString *)pickerView:(AFPickerView *)pickerView titleForRow:(NSInteger)row;

@end



@protocol AFPickerViewDelegate <NSObject>

- (void)pickerView:(AFPickerView *)pickerView didSelectRow:(NSInteger)row;

@end