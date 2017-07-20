//
//  MediaPickerViewController.m
//  lasyFmCoreData
//
//  Created by robbie w on 4/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MediaPickerViewController.h"
#import "MediaPickerTableViewController.h"



@implementation MediaPickerViewController

@synthesize sub_controller;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    
    
    
    sub_controller = [[MediaPickerTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    [self createNavControllerWithViewController:sub_controller];
}



@end
