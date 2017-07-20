//
//  CalendarViewController.m
//  last_fm
//
//  Created by robbie w on 2/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarSubViewController.h"
#import "Events.h"


@implementation CalendarViewController

@synthesize sub_controller;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Calendar" image:[UIImage imageNamed:@"calendarIcon.png"] tag:3];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showView:) name:SHOW_CAL_NO_CONTENT_VIEW object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideView:) name:HIDE_CAL_NO_CONTENT_VIEW object:nil];
        
        [self addNoContentView];

    }
    return self;
}

-(void)addNoContentView{
    self.no_content_view = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].applicationFrame.size.width / 2 - (169/2), [UIScreen mainScreen].applicationFrame.size.height / 2 - (92/2), 169, 92)];
    self.no_content_view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"calendarEmpty.png"]];
    
    [self.view addSubview:self.no_content_view];
    
    [super addNoContentView];
}




#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    
    sub_controller = [[CalendarSubViewController alloc] init];
    
    [self createNavControllerWithViewController:sub_controller];

}




@end
