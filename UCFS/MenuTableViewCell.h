//
//  MenuTableViewCell.h
//  FitHeart
//
//  Created by Bitgears on 14/07/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"

@interface MenuTableViewCell : UITableViewCell {
    MenuItem* menuItem;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withMenuItem:(MenuItem*)item;

@end
