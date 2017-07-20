//
//  SavedViewController.m
//  last_fm
//
//  Created by robbie w on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FavViewController.h"
#import "FavSubViewController.h"

@implementation FavViewController
@synthesize sub_controller;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Favorites" image:[UIImage imageNamed:@"heart.png"] tag:2];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showView:) name:SHOW_FAV_NO_CONTENT_VIEW object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideView:) name:HIDE_FAV_NO_CONTENT_VIEW object:nil];
        
        [self addNoContentView];
        


    }
    return self;
}

-(void)addNoContentView{
    self.no_content_view = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].applicationFrame.size.width / 2 - (169/2), [UIScreen mainScreen].applicationFrame.size.height / 2 - (92/2), 169, 92)];
    
    UIButton *addFavsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 169, 92)];
    [addFavsButton setBackgroundImage:[UIImage imageNamed:@"favoritesEmpty.png"] forState:UIControlStateNormal];

    
    [self.no_content_view addSubview:addFavsButton];
    [self.view addSubview:self.no_content_view];
    [addFavsButton addTarget:self action:@selector(addFavClick) forControlEvents:UIControlEventTouchUpInside];
    [super addNoContentView];
}

-(void)addFavClick{
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_MEDIA_PICKER object:nil]; 

}


 

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    
    sub_controller = [[FavSubViewController alloc] init];
    [self createNavControllerWithViewController:sub_controller];
}



@end
