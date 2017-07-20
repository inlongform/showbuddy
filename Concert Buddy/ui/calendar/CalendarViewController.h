//
//  CalendarViewController.h
//  last_fm
//
//  Created by robbie w on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarSubViewController.h"
#import "AbsractViewController.h"

@interface CalendarViewController : AbsractViewController


@property (strong, nonatomic) CalendarSubViewController *sub_controller;

@end
