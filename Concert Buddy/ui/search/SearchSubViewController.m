//
//  SearchSubViewController.m
//  last_fm
//
//  Created by robbie w on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchSubViewController.h"
#import "ButtonUtil.h"
#import "DataController.h"
#import "AppDelegate.h"
#import "ArtistDetailView.h"

@interface SearchSubViewController()

@property (strong, nonatomic)UITextField *artist_input;

@end

@implementation SearchSubViewController

@synthesize artist_input;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Search Artists";

        // Custom initialization
    }
    return self;
}



#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[Constants defaultFrame]];
    self.view.backgroundColor = [UIColor clearColor];
    
    UIView *txtBck = [[UIView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].applicationFrame.size.width / 2) - 144, 40, 288, 35)];   
    txtBck.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"textField.png"]];
    
    
    [self.view addSubview:txtBck];

    
    artist_input = [[UITextField alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].applicationFrame.size.width / 2) - 130, 40, 265, 35)];       
	artist_input.borderStyle = UITextBorderStyleNone;
    artist_input.clearsOnBeginEditing = YES;
    artist_input.clearButtonMode = YES;
    artist_input.placeholder = @"Enter Artist";
    artist_input.delegate = self;
    artist_input.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    [self.view addSubview:artist_input];
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 290, 40)];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchPress) forControlEvents:UIControlEventTouchUpInside];
    
    int xloc = self.view.frame.size.width / 2 - searchButton.frame.size.width / 2;
    
    searchButton.frame = CGRectMake(xloc, CGRectGetMaxY(txtBck.frame) + 10, searchButton.frame.size.width, searchButton.frame.size.height);
    
    [self.view addSubview:searchButton];
    
    UIButton *addFavorites = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 290, 40)];
    [addFavorites setBackgroundImage:[UIImage imageNamed:@"searchLibrary.png"] forState:UIControlStateNormal];
    [addFavorites addTarget:self action:@selector(addFavoritesPress) forControlEvents:UIControlEventTouchUpInside];
    
    addFavorites.frame = CGRectMake(xloc, CGRectGetMaxY(searchButton.frame) + 10, searchButton.frame.size.width, searchButton.frame.size.height);
    
    
    [self.view addSubview:addFavorites];

}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(artist_input.isFirstResponder) {
        [artist_input resignFirstResponder];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    [artist_input resignFirstResponder];
    
//    if([artist_input text] == nil || [[artist_input text] length] < 1){
//        [artist_input resignFirstResponder];
//    }else{
//        [self searchPress];
//    }
    return YES;
}

-(void)searchPress{
    
    [artist_input resignFirstResponder];
    
    NSLog(@"Search Artist");
    
    
    if([artist_input text] == nil || [[artist_input text] length] < 1){
        NSLog(@"there is no value");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search Error" message:@"Please Enter an Artist" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_INDICATOR object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoaded:) name:ARTIST_DATA_LOADED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadError:) name:ARTIST_LOAD_ERROR object:nil];
        DataController *data_controller = [AppDelegate getDataController];
        
        [data_controller loadArtistDataWithName:[artist_input text]];
        
        
        
    }
    
    
}

- (void)dataLoaded:(NSNotification *)notification{
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_INDICATOR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ARTIST_DATA_LOADED object:nil];
    
    DataController *data_controller = [AppDelegate getDataController];

    ArtistDetailView *artistDetailView = [[ArtistDetailView alloc] initWithStyle:UITableViewStyleGrouped artistData:data_controller.artist_details];
    [self.navigationController pushViewController:artistDetailView animated:YES];
    
}

- (void)dataLoadError:(NSNotification *)notification{
    
    NSLog(@"the artist could not be found");
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_INDICATOR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ARTIST_LOAD_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ARTIST_DATA_LOADED object:nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search Error" message:@"The artist you supplied could not be found" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show];
}

-(void)addFavoritesPress{
    [artist_input resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_MEDIA_PICKER object:nil]; 
    
}




@end
