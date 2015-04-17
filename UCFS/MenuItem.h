//
//  MenuItem.h
//  FitHeart
//
//  Created by Bitgears on 12/11/13.
//  Copyright (c) 2013 VPD. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface MenuItem : NSObject {
    NSString *title;
    UIImage *thumbImage;
    UIImage *thumbOnImage;
    int menuType;
}

@property (strong) NSString *title;
@property (strong) UIImage *thumbImage;
@property (strong) UIImage *thumbOnImage;
@property (assign) int menuType;

- (id)initWithTitle:(NSString*)menuTitle;
- (id)initWithTitle:(NSString*)menuTitle thumbImageFileName:(NSString *)thumbFileName;
- (id)initWithTitle:(NSString*)menuTitle thumbImageFileName:(NSString *)thumbFileName withType:(int)type;
- (id)initWithTitle:(NSString*)menuTitle thumbImageFileName:(NSString *)thumbFileName thumbOnImageFileName:(NSString *)thumbOnFileName withType:(int)type;

@end
