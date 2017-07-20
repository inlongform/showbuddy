//
//  BrowseViewController.m
//  last_fm
//
//  Created by robbie w on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BrowseViewController.h"
#import "BrowseIntro.h"



@implementation BrowseViewController
@synthesize browse_intro;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
          self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Browse" image:[UIImage imageNamed:@"74-location.png"] tag:0];
//        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:NSLocalizedString(@"Browse", nil) image:[UIImage imageNamed:@"74-location.png"] tag:0];
    }
    return self;
}


#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    
    [super loadView];
    
    
    browse_intro = [[BrowseIntro alloc] init];
    
    
    [self createNavControllerWithViewController:browse_intro];
    
}



@end
