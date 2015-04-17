//
//  EffortTableViewCell.m
//  FitHeart
//
//  Created by Bitgears on 12/08/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import "EffortTableViewCell.h"
#import "UCFSUtil.h"

@implementation EffortTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withMenuItem:(MenuItem*)item
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        menuItem = item;
        [self setAccessibilityLabel:[NSString stringWithFormat:@"%@ option" , menuItem.title]  ];
        [self setAccessibilityValue:@"not selected"];
        [self setAccessibilityHint:@"tap to select"];
    }
    return self;
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
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont fontWithName:@"SourceSansPro-Bold" size:18.0];;
        self.imageView.image = menuItem.thumbOnImage;
        [self setBackgroundColor:[UIColor colorWithRed:0.0/255.0 green:108.0/255.0 blue:136.0/255.0 alpha:1.0]];
        
        [self setAccessibilityValue:@""];
        [self setAccessibilityHint:@""];

    }
    else {
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = [UIFont fontWithName:@"SourceSansPro-Light" size:18.0];;
        self.imageView.image = menuItem.thumbImage;
        [self setBackgroundColor:[UIColor clearColor]];
        
        [self setAccessibilityValue:@"not selected"];
        [self setAccessibilityHint:@"tap to select"];

    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if ([UCFSUtil deviceIs3inch]) {
        self.imageView.frame = CGRectMake(70, 0, 50, 50);

    }
    else {
        self.imageView.frame = CGRectMake(70, 8, 50, 50);

    }

    
        self.imageView.contentMode = UIViewContentModeCenter;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
