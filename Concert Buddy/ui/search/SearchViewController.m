//
//  SearchViewController.m
//  last_fm
//
//  Created by robbie w on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchSubViewController.h"

@implementation SearchViewController

@synthesize sub_controller;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Artists" image:[UIImage imageNamed:@"magnifyingglass.png"] tag:1];
//        self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemSearch tag:1];


        
        // Custom initialization
    }
    return self;
}




// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{

    
    [super loadView];
    
    sub_controller = [[SearchSubViewController alloc] init];
    
    [self createNavControllerWithViewController:sub_controller];
    
    
}




@end
