//
//  SavedViewController.h
//  last_fm
//
//  Created by robbie w on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbsractViewController.h"
@class FavSubViewController;


@interface FavViewController : AbsractViewController

@property (strong, nonatomic) FavSubViewController *sub_controller;

@end
