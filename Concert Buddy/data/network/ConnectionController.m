//
//  ConnectionController.m
//  FoursquareTest
//
//  Created by Xichuan Wang on 12/6/11.
//  Copyright (c) 2011 TENDER. All rights reserved.
//

#import "ConnectionController.h"
#import "Reachability.h"


// private methods
@interface ConnectionController()

- (void) checkNetworkStatus:(NSNotification *)notice;

// connection checking
@property (nonatomic)  BOOL internetActive, hostActive, haveCheckedHost, haveCheckedInternet;
@property (strong, nonatomic) Reachability *internetReachable;
@property (strong, nonatomic) Reachability *hostReachable;

@end


@implementation ConnectionController

@synthesize internetReachable, internetActive, hostActive, haveCheckedHost, haveCheckedInternet;
@synthesize hostReachable;
@synthesize delegate;

///////////////////////////////////////////////////
// Loads data from the CMS
////////////// /////////////////////////////////////

- (void)checkConnection {

    // check for internet connectionwhat sh
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
    
    hostReachable = [Reachability reachabilityWithHostname: [Constants baseConnectionURL]];
    [hostReachable startNotifier];

    // see if Internet is reachable
    internetReachable = [Reachability reachabilityForInternetConnection];
    [internetReachable startNotifier];
    
    
}


- (void) checkNetworkStatus:(NSNotification *)notice
{
    
	// called after network status changes
	
	NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
	switch (internetStatus)
	{
		case NotReachable:
		{
			//NSLog(@"The internet is down.");
			internetActive = NO;
			haveCheckedInternet = YES;
			break;
			
		}
		case ReachableViaWiFi:
		{
			//NSLog(@"The internet is working via WIFI.");
			internetActive = YES;
			haveCheckedInternet = YES;
			break;
		}
            
		case ReachableViaWWAN:
		{
			//NSLog(@"The internet is working via WWAN.");
			internetActive = YES;
			haveCheckedInternet = YES;
			break;
			
		}
	}
	


    NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
	switch (hostStatus)
	{	
		case NotReachable:
		{
			//NSLog(@"A gateway to the host server is down.");
			hostActive = NO;
			haveCheckedHost = YES;
			break;
			
		}
		case ReachableViaWiFi:
		{
			//NSLog(@"A gateway to the host server is working via WIFI.");
			hostActive = YES;
			haveCheckedHost = YES;
			break;
			
		}
		case ReachableViaWWAN:
		{
			//NSLog(@"A gateway to the host server is working via WWAN.");
			hostActive = YES;
			haveCheckedHost = YES;
			break;
			
		}
	}
    
    if( internetActive ){
        [self.delegate connectedWithConnector: self withResponse: YES];
    }else {
        [self.delegate connectedWithConnector: self withResponse: NO];
    }
    
}

@end
