//
//  AbsractViewController.m
//  lasyFmCoreData
//
//  Created by robbie w on 3/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AbsractViewController.h"
#import "Constants.h"

@implementation AbsractViewController

@synthesize nav_controller, no_content_view;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        // Custom initialization
    }
    return self;
}


-(void)createNavControllerWithViewController:(UIViewController *)controller{
    nav_controller = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self.nav_controller.navigationBar setBackgroundImage:[UIImage imageNamed:@"navWhiteBck.png"] forBarMetrics:UIBarMetricsDefault];

    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], UITextAttributeTextColor, [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset, [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0], UITextAttributeTextShadowColor,nil]];

    UIImage *button30 = [[UIImage imageNamed:@"editButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [[UIBarButtonItem appearance] setBackgroundImage:button30 forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    
    [[UIBarButtonItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:1.0], UITextAttributeTextColor, 
      [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0], UITextAttributeTextShadowColor, 
      [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset, 
      nil] forState:UIControlStateNormal];
    
    UIImage *buttonBack30 = [[UIImage imageNamed:@"backBtn"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 13, 0, 5)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:buttonBack30 forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
  
    [self.view addSubview:nav_controller.view];
}

-(void)loadView{
    self.view = [[UIView alloc] initWithFrame:[Constants defaultFrame]];    
    self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"dark_dotted.png"]];
//    [super loadView];
}

-(void)addNoContentView{
    [no_content_view setHidden:YES];
}

- (void)showView:(NSNotification *)notification{
    [no_content_view setHidden:NO];
}

- (void)hideView:(NSNotification *)notification{
    [no_content_view setHidden:YES];
}


@end
