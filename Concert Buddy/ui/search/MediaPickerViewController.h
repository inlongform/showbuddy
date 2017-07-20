//
//  MediaPickerViewController.h
//  lasyFmCoreData
//
//  Created by robbie w on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AbsractViewController.h"
#import "MediaPickerTableViewController.h"

@interface MediaPickerViewController : AbsractViewController

@property (strong, nonatomic) MediaPickerTableViewController *sub_controller;

@end
