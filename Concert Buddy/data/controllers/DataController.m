//
//  Data_Controller.m
//  last_fm
//
//  Created by robbie w on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DataController.h"
#import "ArtistEventData.h"
#import "EventDetailsData.h"
#import "ArtistDetailData.h"
#import "AllArtistEventsData.h"
#import "ConnectionController.h"


@interface DataController()



@property (strong, nonatomic) ConnectionController *connection_controller;

@property (nonatomic) int artistDataLoadCount;

-(void)artistDataReady;

@end


@implementation DataController

@synthesize connection_controller, hasConnection, hasTracks, artist_event, masterArtistArray, loopCount, currentPage, event_details_data, artist_details, allEventsArray, tracksArray, totalEvents, artistDataLoadCount;

-(id)init{
    if (self = [super init]) {
        masterArtistArray = [[NSMutableArray alloc] init];
        tracksArray = [[NSMutableArray alloc] init];
        
        artistDataLoadCount = 0;
        
        
        connection_controller = [[ConnectionController alloc] init];
        connection_controller.delegate = self;
        [connection_controller checkConnection];
    }
    
    return self;
}

-(void) connectedWithConnector: (ConnectionController*) controller withResponse: (BOOL) isConnected{
    NSLog(@"the network connection is: %d", isConnected);
    
    hasConnection = isConnected;
    

}

-(void)showConnectionAlert{
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_INDICATOR object:nil];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Search Error" message:@"Can't connect to the internet" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show];
}

-(void)loadDataWithLocation:(NSString *)location andPage:(int)pageNum isCurrentLocation:(Boolean)isCurrent{

    if(hasConnection){
        NSMutableArray *event_list = [[NSMutableArray alloc] init];
        
        NSString *pageString = [[NSString alloc] initWithFormat:@"%d", pageNum];
        
        NSString *finalGenre;

        
        if(![[Constants getGenre] isEqualToString:@"all"]){
            NSString *addGenre = @"&tag=";
            finalGenre = [addGenre stringByAppendingString:[[Constants getGenre] urlencode]];
            
        }else{
            finalGenre = @"";
        }

        

        
        NSString *finalEventURL;
            
        if(isCurrent){
            CLLocation *userLocation = [Constants getlocationLatLong];
            
            NSString *lat = [[NSString alloc] initWithFormat:@"%g", userLocation.coordinate.latitude];
            NSString *lo = [[NSString alloc] initWithFormat:@"%g", userLocation.coordinate.longitude];
            
            NSString *latEventsURL = [[Constants getShowsURLWithLatLong] stringByReplacingOccurrencesOfString:@"LATITUDE" withString:lat];
            NSString *longEventsURL = [latEventsURL stringByReplacingOccurrencesOfString:@"LONGITUDE" withString:lo];
            NSString *distanceURL = [longEventsURL stringByReplacingOccurrencesOfString:@"DISTANCE" withString:[Constants getRadius]];
            NSString *genreURL = [distanceURL stringByAppendingString:finalGenre];
            finalEventURL = [genreURL stringByReplacingOccurrencesOfString:@"PAGENUM" withString:pageString];

        
        }else{
            //lastfm does not like new york city for some reason
            
            NSString *newLocation = [[NSString alloc] initWithString:location];
            NSString *lowerCaseLocation = [newLocation lowercaseString];
            
            if([lowerCaseLocation isEqualToString:@"new york city"]){
                lowerCaseLocation = @"new york";
            }else{
                lowerCaseLocation = location;
            }
            NSString *encodedLocation = [lowerCaseLocation urlencode];
            NSString *locationEventsURL = [[Constants getShowsURL] stringByReplacingOccurrencesOfString:@"CITYNAME" withString:encodedLocation];
            NSString *distanceURL = [locationEventsURL stringByReplacingOccurrencesOfString:@"DISTANCE" withString:[Constants getRadius]];
            NSString *genreURL = [distanceURL stringByAppendingString:finalGenre];
            finalEventURL = [genreURL stringByReplacingOccurrencesOfString:@"PAGENUM" withString:pageString];
        }
        

        
            
            NSLog(@"Artist Select URL: %@", finalEventURL);
            
            NSURL *eventsURL = [NSURL URLWithString:finalEventURL];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:eventsURL];
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            
            [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, 
                                                                                             NSData *data, 
                                                                                             NSError *error){
                
                
                
                if (error == nil){
                    SBJsonParser *json_parser = [[SBJsonParser alloc] init];
                    NSDictionary *dict = [json_parser objectWithData:data];
                    

                    
                    NSString *isError= [dict objectForKey:@"error"];
                     
                    if(isError != nil ){

                        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:[dict objectForKey:@"message"] forKey:@"errorTxt"];


                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [[NSNotificationCenter defaultCenter] postNotificationName:DATA_LOAD_ERROR object:nil userInfo:userInfo];
                        });
                        
                        return;
                    }
                    

                    NSDictionary *events = [dict objectForKey:@"events"];

                    
                    NSArray *event = [events objectForKey:@"event"];
                    
                    if([[events objectForKey:@"event"] isKindOfClass:[NSDictionary class]]){
                        NSLog(@"event a dictionary");
                        artist_event = [[ArtistEventData alloc] initWidthDictionary:[events objectForKey:@"event"]];
                        [event_list addObject:artist_event];
                    }else{
                        
                        for(int i = 0; i < event.count; i++){
                            
                            NSDictionary *eventDetails = [event objectAtIndex:i];
                            artist_event = [[ArtistEventData alloc] initWidthDictionary:eventDetails];
                            
                            
                            [event_list addObject:artist_event];
                            
                        }

                    }
                                        
                    [self updateMasterList:event_list];
                    
                }else{
                    
                    [self loadError];
                    
                }
                
            }];
    }else{
        
        [self showConnectionAlert];
    }

}

-(void)updateMasterList:(NSMutableArray *)events{
    
    NSString *currEventDate = @"";
    NSString *prevEventDate = @"";
    
    
    
    for (int i = 0; i < [events count]; i++) {
        ArtistEventData *currEvent = [events objectAtIndex:i];
        
        prevEventDate = currEventDate;
        currEventDate = currEvent.shortDate;
        
        
        if([prevEventDate isEqualToString:currEventDate] == NO)  {
            
            loopCount++;
            
            [masterArtistArray addObject:[[NSMutableArray alloc] init]];
            
        }
        
        [[masterArtistArray objectAtIndex:loopCount] addObject:currEvent];

        
        
        
    }
//    NSLog(@"------------");

    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:BROWSE_DATA_LOADED object:nil]; 
    });
}

-(void)resetMasterArray{
    loopCount = -1;
    currentPage = 1;
    [masterArtistArray removeAllObjects];
}

-(void)loadEventDetailDataWidthId:(NSString *)eventId{
   
    if(hasConnection){
        NSString *eventsURL = [[Constants getEventURL] stringByReplacingOccurrencesOfString:@"EVENTID" withString:eventId];
        NSURL *eventEncodeURL = [[NSURL alloc] initWithString:eventsURL];
        
        NSLog(@"event URL %@", eventEncodeURL);
        
        
        NSURLRequest *request = [NSURLRequest requestWithURL:eventEncodeURL];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, 
                                                                                         NSData *data, 
                                                                                         NSError *error){
            
            if (error == nil){
                SBJsonParser *json_parser = [[SBJsonParser alloc] init];
                NSDictionary *dict = [json_parser objectWithData:data];
    //            NSLog(@"dict: %@", dict);
                NSDictionary *event = [dict objectForKey:@"event"];

                
                event_details_data = [[EventDetailsData alloc] initWithDataDictionary:event eventURL:eventEncodeURL];
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_DATA_LOADED object:nil]; 
                });

            }else{
                
                [self loadError];
                
            }
        }]; 
    }else{
        [self showConnectionAlert];
    }
    

    

}

-(void)loadArtistDataWithName:(NSString *)artistName{
    
    if(hasConnection){
        
        artistDataLoadCount = 0;
        
        [self loadAllArtistEventsWithName:artistName isPage:NO];
    
        NSString *encodedArtistName = [artistName urlencode];
        NSString *detailURL = [[Constants getArtistInfoURL] stringByReplacingOccurrencesOfString:@"ARTIST" withString:encodedArtistName];

        NSURL *artistDetailURL = [NSURL URLWithString:detailURL];
        
        NSLog(@"artistDetailURL %@", artistDetailURL);
        
        
        NSURLRequest *request = [NSURLRequest requestWithURL:artistDetailURL];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, 
                                                                                         NSData *data, 
                                                                                         NSError *error){
            if (error == nil){
                SBJsonParser *json_parser = [[SBJsonParser alloc] init];
                NSDictionary *dict = [json_parser objectWithData:data];
                
                
                
                

                
                NSString *validArtist= [dict objectForKey:@"error"];
                

                
                if(validArtist != NULL){
                    NSLog(@"there is an error");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:ARTIST_LOAD_ERROR object:nil]; 
                    });
                }else{
                    artist_details = [[ArtistDetailData alloc] initWithDictionary:dict];
                    
                    [self artistDataReady];
                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [[NSNotificationCenter defaultCenter] postNotificationName:ARTIST_DATA_LOADED object:nil]; 
//                    });
                }
                

                
            }else{
                
                [self loadError];
                
            }
            
        }];
    }else{
        [self showConnectionAlert];
    }
    
}

-(void)loadError{
    NSLog(@"load error");
    [[NSNotificationCenter defaultCenter] postNotificationName:HIDE_INDICATOR object:nil]; 
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Load Error" message:@"Please Try Again" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    [alert show];
}

-(void)loadAllArtistEventsWithName:(NSString *)artistName isPage:(Boolean)page{
    
    if(hasConnection){
//        [allEventsArray removeAllObjects];
        
        NSString *encodedArtistName = [artistName urlencode];
        NSString *artistEventsURL = [[Constants getArtistEventInfoURL] stringByReplacingOccurrencesOfString:@"ARTIST" withString:encodedArtistName];
        NSURL *eventsURL = [NSURL URLWithString:artistEventsURL];
        
        NSLog(@"eventsURL: %@", eventsURL);
        
        NSURLRequest *request = [NSURLRequest requestWithURL:eventsURL];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, 
                                                                                         NSData *data, 
                                                                                         NSError *error){
            if (error == nil){
                allEventsArray = [[NSMutableArray alloc] init];
                SBJsonParser *json_parser = [[SBJsonParser alloc] init];
                NSDictionary *dict = [json_parser objectWithData:data];
                
                NSDictionary *events = [dict objectForKey:@"events"];
                



                //last fm api is retarded
                
                if([[events objectForKey:@"event"] isKindOfClass:[NSDictionary class]]){
                    AllArtistEventsData *singleEvent = [[AllArtistEventsData alloc] initWithDictionary:[events objectForKey:@"event"]];
                    [allEventsArray addObject:singleEvent];
                }else if([[events objectForKey:@"event"] isKindOfClass:[NSArray class]]){
                    NSArray *event = [[NSArray alloc] initWithArray:[events objectForKey:@"event"]];
                    for(int i = 0; i < [event count]; i++){
                        NSDictionary *eventDict = [event objectAtIndex:i];
                        AllArtistEventsData *allEvents = [[AllArtistEventsData alloc] initWithDictionary:eventDict];
                        [allEventsArray addObject:allEvents];
                    
                    }
                }
                
                totalEvents = [allEventsArray count];
                
                if(page){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"number of events %d", totalEvents);
                        [[NSNotificationCenter defaultCenter] postNotificationName:ALL_EVENTS_LOADED object:nil]; 
                    });
                }else{
                    [self artistDataReady];
                }
                
               

                
            }else{
                [self loadError];
            }
            
        }];
    }else{
        [self showConnectionAlert];
    }

}

-(void)artistDataReady{
    artistDataLoadCount++;
    
    if(artistDataLoadCount >= 2){
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:ARTIST_DATA_LOADED object:nil]; 
        });
        
        NSLog(@"ready totalEvents %d", totalEvents);
    }
}



-(void)loadSongSampleData:(NSString *)artistName{
    
    hasTracks = NO;
    
    NSString *encodedArtistName = [artistName urlencode];
    NSString *artistEventsURL = [[Constants getItunesURL] stringByReplacingOccurrencesOfString:@"ARTIST" withString:encodedArtistName];
    NSURL *sampleURL = [NSURL URLWithString:artistEventsURL];
    
    NSLog(@"sampleURL: %@", sampleURL);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:sampleURL];
  
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, 
                                                                                     NSData *data, 
                                                                                     NSError *error){
        if (error == nil){

            SBJsonParser *json_parser = [[SBJsonParser alloc] init];
            NSDictionary *dict = [json_parser objectWithData:data];
            
            

            
            NSString *resultCount = [dict objectForKey:@"resultCount"];
            NSArray *results = [dict objectForKey:@"results"];
            
            
            int resultNum = (int)([resultCount doubleValue]);
            
            NSString *artistNameLower = [artistName lowercaseString];
            
            int count = 0;
            int maxCount = 5;
            
            [tracksArray removeAllObjects];

            if(resultNum == 0){
                hasTracks = NO;

            }else{
                hasTracks = YES;

                //get the data when the artistName and the itunes artistName match
                for(int i = 0; i < [results count]; i++){
                    NSDictionary *artistDict = [results objectAtIndex:i];
                    NSString *dataArtistName = [artistDict objectForKey:@"artistName"];
                    NSString *dataArtistNameLower = [dataArtistName lowercaseString];
                    
                    if([dataArtistNameLower isEqualToString:artistNameLower]){
                        


                        
                        NSString *songURL = [artistDict objectForKey:@"previewUrl"];
                        //find and replace 100x100 to 1200x1200 to get a larger image
                        NSString *artWorkURL = [artistDict objectForKey:@"artworkUrl100"];
                        NSString *trackName = [artistDict objectForKey:@"trackName"];
                        NSString *itunesURL = [artistDict objectForKey:@"trackViewUrl"];
                    
                      
                        NSDictionary *trackDict = [[NSDictionary alloc] initWithObjectsAndKeys:artist_details.artist_name, @"artistName", songURL, @"songURL", artWorkURL, @"artWorkURL", trackName, @"trackName", itunesURL, @"itunesUrl", nil];
                        


                        [tracksArray addObject:trackDict];
                        
                        count++;
                        if(count >= maxCount){
                            break;
                        }

                    }
                    
                    
                    
                    
                    
                }  
                
                if([tracksArray count] == 0){
                    hasTracks = NO;
                }
            
//                NSLog(@"count %d", [tracksArray count]);

            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:SONG_SAMPLE_LOADED object:nil]; 
            });

        }else{
            hasTracks = NO;
        }
        
    }];
}


@end
