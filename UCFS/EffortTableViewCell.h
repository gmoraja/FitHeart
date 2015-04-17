//
//  EffortTableViewCell.h
//  FitHeart
//
//  Created by Bitgears on 12/08/14.
//  Copyright (c) 2014 VPD. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuItem.h"

@interface EffortTableViewCell : UITableViewCell {
    MenuItem* menuItem;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withMenuItem:(MenuItem*)item;


@end
