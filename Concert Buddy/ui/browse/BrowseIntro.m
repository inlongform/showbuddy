//
//  BrowseIntro.m
//  last_fm
//
//  Created by robbie w on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BrowseIntro.h"
#import "ButtonUtil.h"
#import "Constants.h"
#import "ButtonUtil.h"
#import "BrowseCity.h"
#import "AppDelegate.h"
#import "DataController.h"
#import "DistanceUtil.h"
#import "SettingsView.h"


#import <CoreLocation/CoreLocation.h>

@interface BrowseIntro()

@property (strong, nonatomic) UITextField *city_input;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) DataController *data_controller;
//@property (strong, nonatomic) SettingsView *settings_view;

@property (nonatomic)Boolean isCurrentLocation;

@end

@implementation BrowseIntro

@synthesize city_input, locationManager, data_controller, isCurrentLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Browse";
        data_controller = [AppDelegate getDataController];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadError:) name:DATA_LOAD_ERROR object:nil];
        
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
    
    
    city_input = [[UITextField alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].applicationFrame.size.width / 2) - 130, 40, 265, 35)];
	city_input.borderStyle = UITextBorderStyleNone;
    city_input.clearsOnBeginEditing = YES;
    city_input.clearButtonMode = YES;
    city_input.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    city_input.placeholder = @"Enter City";
    city_input.delegate = self;
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 290, 40)];
    [searchButton setBackgroundImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(searchPress) forControlEvents:UIControlEventTouchUpInside];
    
    int xloc = self.view.frame.size.width / 2 - searchButton.frame.size.width / 2;
    searchButton.frame = CGRectMake(xloc, CGRectGetMaxY(txtBck.frame) + 10, searchButton.frame.size.width, searchButton.frame.size.height);

    
    
    
    UIButton *locationButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 182, 45)];
    [locationButton setBackgroundImage:[UIImage imageNamed:@"currentLocationButton.png"] forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(locationPress) forControlEvents:UIControlEventTouchUpInside];
    
    xloc = self.view.frame.size.width / 2 - locationButton.frame.size.width / 2;
    locationButton.frame = CGRectMake(xloc, CGRectGetMaxY(searchButton.frame) + 10, locationButton.frame.size.width, locationButton.frame.size.height);
    
    SettingsView *settings_view = [[SettingsView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].applicationFrame.size.height - 230, [UIScreen mainScreen].applicationFrame.size.width, 136)];
    [self.view addSubview:settings_view];

    
    
    
	[self.view addSubview:locationButton]; 
    [self.view addSubview:searchButton]; 
	[self.view addSubview:city_input];
    

}



-(void) locationPress{
    
    isCurrentLocation = YES;
    if(data_controller.hasConnection){
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_INDICATOR object:nil];
        
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
        
        
        [locationManager startUpdatingLocation];
    }else{
        [data_controller showConnectionAlert];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        if( !error ){
            
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            
            
            
            
            
            [Constants setCurrentCity:placemark.locality];
            [Constants setlocationWithLat:newLocation.coordinate.latitude andLongitude:newLocation.coordinate.longitude];
            

            
            
            NSLog(@"%@%@", self, [Constants getCurrentCity]);
            NSLog(@"%@%@", self, [Constants getlocationLatLong]);
            
            //get the closest city to the user
            NSString *closestCity = [DistanceUtil getClosestCityWith:newLocation.coordinate.latitude andLong:newLocation.coordinate.longitude];
            
            [Constants setCurrentCity:closestCity];            
            
            //end get the closest city to the user

       
            [self locationReady];
            
        }else {
            
            
        }
        
    }];
    
    [locationManager stopUpdatingLocation];
    
}

-(void) searchPress{
    
    isCurrentLocation = NO;
    [city_input resignFirstResponder];
    
    
    if([city_input text] == nil || [[city_input text] length] < 1){
        NSLog(@"there is no value");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search Error" message:@"Please Enter a Location" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }else{
        [Constants setCurrentCity:[city_input text]];
        NSLog(@"Search for stuff %@", [Constants getCurrentCity]);
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOW_INDICATOR object:nil];
        
        [self locationReady];
        
        
         
    }
    
    
}

- (void)loadError:(NSNotification *)notification{
    
    NSString *errorTxt = [[notification userInfo] objectForKey:@"errorTxt"];
    
    
    NSMutableString *errorMsg = [[NSMutableString alloc] initWithString:errorTxt];
    [errorMsg appendString:@"\n"];
    [errorMsg appendFormat:@"%@", [city_input text]];


    
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_INDICATOR object:nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search Error" message:errorMsg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];

    [alert show];
}

-(void)locationReady{

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoaded:) name:BROWSE_DATA_LOADED object:nil];
    
//    NSLog(@" currentPage %d", data_controller.currentPage);
    
    [data_controller resetMasterArray];
   
    [data_controller loadDataWithLocation:[Constants getCurrentCity] andPage:data_controller.currentPage isCurrentLocation:isCurrentLocation];
    


}

- (void)dataLoaded:(NSNotification *)notification{
    
//    NSLog(@"loaded");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_INDICATOR object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:BROWSE_DATA_LOADED object:nil];
      

    BrowseCity *browse_city = [[BrowseCity alloc] initWithStyle:UITableViewStyleGrouped andEvents:data_controller.masterArtistArray isCurrentLocation:isCurrentLocation];
    [self.navigationController pushViewController:browse_city animated:YES];

    
}






-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(city_input.isFirstResponder) {
        [city_input resignFirstResponder];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    
    [city_input resignFirstResponder];
    
//    if([city_input text] == nil || [[city_input text] length] < 1){
//        [city_input resignFirstResponder];
//    }else{
//        [self searchPress];
//    }
    return YES;
}




@end
