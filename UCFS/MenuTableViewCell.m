//
//  MenuTableViewCell.m
//  FitHeart
//
//  Created by Bitgears on 14/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withMenuItem:(MenuItem*)item
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        menuItem = item;
        if (menuItem.menuType==7) {
            [self setIsAccessibilityElement:NO];
            self.userInteractionEnabled = FALSE;
        }
        else {
            [self setIsAccessibilityElement:YES];
            [self setAccessibilityLabel:[NSString stringWithFormat:@"%@ button", menuItem.title]];
            
        }

    }
    return self;
}

-(UIView*)createContentView {
    UIView* view = [[UIView alloc] initWithFrame:self.frame];
    
    return view;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    [self updateTextColor:selected];
}



- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    [self updateTextColor:highlighted];
}

- (void)updateTextColor:(BOOL)isSelected {
    if (isSelected) {
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = [UIFont fontWithName:@"SourceSansPro-Regular" size:20.0];;
        self.imageView.image = menuItem.thumbOnImage;
        if (menuItem.menuType!=7)
            [self setAccessibilityValue:@"selected"];
    }
    else {
        self.textLabel.textColor = [UIColor colorWithRed:72.0/255.0 green:72.0/255.0 blue:72.0/255.0 alpha:1.0];
        self.textLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:20.0];;
        self.imageView.image = menuItem.thumbImage;
        if (menuItem.menuType!=7)
            [self setAccessibilityValue:@"not selected"];
    }
}

- (NSInteger)accessibilityElementCount {
    if(self.isAccessibilityElement==NO){
        return 0;
    }
    else{
        return [super accessibilityElementCount];
    }
}

@end
