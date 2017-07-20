//
//  Main_view_controller.m
//  last_fm
//
//  Created by robbie w on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "FavViewController.h"
#import "SearchViewController.h"
#import "BrowseViewController.h"
#import "CalendarViewController.h"
#import "DSActivityView.h"
#import "ConnectionController.h"
#import "AbsractViewController.h"
#import "AppDelegate.h"
#import "MediaPickerViewController.h"

#import "CoreDataController.h"
#import "GenrePicker.h"



@interface RootViewController()

@property (strong, nonatomic) UITabBarController *tab_bar_controller;
@property (strong, nonatomic) SearchViewController *search_controller;
@property (strong, nonatomic) FavViewController *fav_controller;
@property (strong, nonatomic) BrowseViewController *browse_controller;
@property (strong, nonatomic) CalendarViewController *calendar_controller;

@property (strong, nonatomic) AbsractViewController *currentTab;
@property (strong, nonatomic) AbsractViewController *prevTab;

@property (strong, nonatomic) MediaPickerViewController *media_picker;


@property (strong, nonatomic) UIActivityIndicatorView *activity_indicator;

@property (strong, nonatomic) CoreDataController *core_data_controller;

@property (strong, nonatomic) GenrePicker *picker;

//@property(nonatomic, assign) AppDelegate *delegate;





@end



@implementation RootViewController

@synthesize tab_bar_controller, fav_controller, search_controller, browse_controller, calendar_controller, currentTab, prevTab, media_picker, activity_indicator, core_data_controller, picker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
   
            
    if (self) {
       
        activity_indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height)];
        activity_indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        
        core_data_controller = [AppDelegate getCoreDataController];
        [self.core_data_controller loadGenres];
        
//        self.delegate = [UIApplication sharedApplication].delegate;
//        
//        
//        [[GAI sharedInstance].defaultTracker sendEventWithCategory:@"secureDispatch"
//                                                        withAction:@"toggle"
//                                                         withLabel:nil
//                                                         withValue:nil];

        
    }
    return self;
}



#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    
    self.view = [[UIView alloc] initWithFrame:[Constants defaultFrame]];
    

    
    tab_bar_controller = [[UITabBarController alloc] init];
    fav_controller = [[FavViewController alloc] init];
    search_controller = [[SearchViewController alloc] init];
    browse_controller = [[BrowseViewController alloc] init];
    calendar_controller = [[CalendarViewController alloc] init];

    
    NSArray *tabControllerArray = [[NSArray alloc] initWithObjects:browse_controller, search_controller, fav_controller, calendar_controller, nil];
    
    
    [tab_bar_controller setViewControllers:tabControllerArray];
    tab_bar_controller.delegate = self;
    
    picker = [[GenrePicker alloc] init];
    


    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoading:) name:SHOW_INDICATOR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideLoading:) name:HIDE_INDICATOR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPicker:) name:SHOW_MEDIA_PICKER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removePicker:) name:REMOVE_MEDIA_PICKER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAudioPlayer:) name:SHOW_AUDIO_PLAYER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideLibraryLoader:) name:HIDE_LIBRARY_INDICATOR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showGenrePicker:) name:SHOW_GENRE_PICKER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideGenrePicker:) name:HIDE_GENRE_PICKER object:nil];

    
    [self.view addSubview:tab_bar_controller.view];
    [self.view addSubview:picker.view];
    picker.view.frame = CGRectMake(0,[UIScreen mainScreen].applicationFrame.size.height,[UIScreen mainScreen].applicationFrame.size.width,[UIScreen mainScreen].applicationFrame.size.height);
    

}



-(void)showGenrePicker:(NSNotification *)notification{
    

    
    [UIView beginAnimations:@"frame" context:nil];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [picker viewWillAppear:YES];
    picker.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width,[UIScreen mainScreen].applicationFrame.size.height);
    [picker viewDidAppear:YES];
    
    [UIView commitAnimations];

    
}

-(void)hideGenrePicker:(NSNotification *)notification{
    
    [UIView beginAnimations:@"frame" context:nil];
    [UIView setAnimationDuration:.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [picker viewWillAppear:YES];
    picker.view.frame = CGRectMake(0,[UIScreen mainScreen].applicationFrame.size.height,[UIScreen mainScreen].applicationFrame.size.height,[UIScreen mainScreen].applicationFrame.size.height);
    [picker viewDidAppear:YES];
    [UIView commitAnimations];
    
    
}



-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    prevTab = currentTab;
    currentTab = (AbsractViewController *)viewController;
    
    if(prevTab == currentTab){
        
        [currentTab.nav_controller popToRootViewControllerAnimated:YES];
    }
    
    
}





-(void)showAudioPlayer:(NSNotification *)notification{
    

    
    NSDictionary *dict = [notification userInfo];
    
    NSLog(@"track info %@", dict);
    
    NSString *trackerLbl = [[NSString alloc] initWithFormat:@"listen to: %@", [dict objectForKey:@"artistName"]];
    [AppDelegate trackDataWithEvent:@"listen_to_artist" actions:@"artist" andLbl:trackerLbl];

    
    UIView *imgHolder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width,[UIScreen mainScreen].applicationFrame.size.height)];
    NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [dict objectForKey:@"artWorkURL"]]];
    UIImage *img = [UIImage imageWithData:imageData];
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    imgView.frame = [Constants defaultFrame];
    imgHolder.backgroundColor = [UIColor colorWithPatternImage:img];
    

    NSURL *url = [[NSURL alloc] initWithString:[dict objectForKey:@"songURL"]];

    
    UIGraphicsBeginImageContext(CGSizeMake(1,1));
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL: url];
    UIGraphicsEndImageContext();
    player.moviePlayer.fullscreen = YES;
    player.moviePlayer.backgroundView.backgroundColor = [UIColor clearColor];

    [player.moviePlayer.backgroundView addSubview:imgHolder];
    
    [self presentMoviePlayerViewControllerAnimated:player];

    

}




- (void)showLoading:(NSNotification *)notification{
    [DSBezelActivityView newActivityViewForView:self.view withLabel: @"LOADING RESULTS"];
}

- (void)hideLoading:(NSNotification *)notification{
    [DSBezelActivityView removeViewAnimated:YES];
}

- (void)hideLibraryLoader:(NSNotification *)notification{
    [activity_indicator stopAnimating];
}



- (void)showPicker:(NSNotification *)notification{
//    NSLog(@"show local select");
    
    
    media_picker = [[MediaPickerViewController alloc] initWithNibName:nil bundle:nil];
    
    [self presentModalViewController:media_picker animated:YES];
    
    [media_picker.view addSubview:activity_indicator];
    [activity_indicator startAnimating];

    
}

- (void)removePicker:(NSNotification *)notification{
    [media_picker dismissModalViewControllerAnimated:YES];
//    NSLog(@"remove local select");
}

- (void)invalidLocation:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_INDICATOR object:nil]; 
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search Error" message:@"Location not found" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show];
}





@end
