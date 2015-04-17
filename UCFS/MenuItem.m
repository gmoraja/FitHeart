//
//  MenuItem.m
//  FitHeart
//
//  Created by Bitgears on 12/11/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem

@synthesize title;
@synthesize thumbImage;
@synthesize thumbOnImage;
@synthesize menuType;

- (id)initWithTitle:(NSString*)menuTitle {
    if ((self = [super init])) {
        self.title = menuTitle;
    }
    return self;
}

- (id)initWithTitle:(NSString*)menuTitle thumbImageFileName:(NSString *)thumbFileName {
    if ((self = [super init])) {
        self.title = menuTitle;
        self.thumbImage = [UIImage imageNamed:thumbFileName];
    }
    return self;
}

- (id)initWithTitle:(NSString*)menuTitle thumbImageFileName:(NSString *)thumbFileName withType:(int)type {
    if ((self = [super init])) {
        self.title = menuTitle;
        self.thumbImage = [UIImage imageNamed:thumbFileName];
        self.menuType = type;
    }
    return self;
}

- (id)initWithTitle:(NSString*)menuTitle thumbImageFileName:(NSString *)thumbFileName thumbOnImageFileName:(NSString *)thumbOnFileName withType:(int)type {
    if ((self = [super init])) {
        self.title = menuTitle;
        self.thumbImage = [UIImage imageNamed:thumbFileName];
        self.thumbOnImage = [UIImage imageNamed:thumbOnFileName];
        self.menuType = type;
    }
    return self;
}


@end
