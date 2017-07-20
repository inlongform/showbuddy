//
//  EventDetailsData.m
//  last_fm
//
//  Created by robbie w on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventDetailsData.h"
#import "DateUtil.h"

@implementation EventDetailsData

@synthesize allArtists, allInfo, headLiner, venueName, venueId, titleDate,latitude, longitude, eventId, display_info, calendar_start_date, eventURL, phoneNumber, ticketURL;



-(id)initWithDataDictionary:(NSDictionary *)dict eventURL:(NSURL *)url{
    if (self = [super init]) {
        
        eventURL = url;
        
        NSDictionary *event = [[NSDictionary alloc] initWithDictionary:dict];
        


//        NSLog(@"%@", event);
        
        NSDictionary *artists =[event objectForKey:@"artists"];
        NSDictionary *venueInfo = [event objectForKey:@"venue"];
        NSDictionary *locationInfo = [venueInfo objectForKey:@"location"];
        NSObject *geo = [locationInfo objectForKey:@"geo:point"];
        latitude = [geo valueForKey:@"geo:lat"];
        longitude = [geo valueForKey:@"geo:long"];
        
        if([[artists objectForKey:@"artist"] isKindOfClass:[NSArray class]]){

            allArtists = [[NSMutableArray alloc] initWithArray:[artists objectForKey:@"artist"]]; 
           
        }else{
            allArtists = [[NSMutableArray alloc] initWithObjects:[artists objectForKey:@"artist"], nil]; 

        }
        
        NSString *allArtistsStr = [[NSString alloc] initWithFormat:@"%@", [allArtists componentsJoinedByString:@"\n"] ];
        
        

        
        NSString *street = [locationInfo objectForKey:@"street"];
        NSString *postal = [locationInfo objectForKey:@"postalcode"];
        NSString *city = [locationInfo objectForKey:@"city"];
        phoneNumber = [venueInfo objectForKey:@"phonenumber"];
        NSString *country = [locationInfo objectForKey:@"country"];
        

        
        
        
        eventId = [event objectForKey:@"id"];
        venueName = [venueInfo objectForKey:@"name"];
        headLiner = [artists objectForKey:@"headliner"];
        venueId = [venueInfo objectForKey:@"id"];
        
        display_info = [[NSMutableString alloc] initWithFormat:@"%@", venueName];
        
        if(![street isEqualToString:@""]){
            [display_info appendString:@"\n"];
            [display_info appendString:street];
        }
        
        if(![city isEqualToString:@""]){
            [display_info appendString:@"\n"];
            [display_info appendString:city];
        }
        
        if(![postal isEqualToString:@""]){
            [display_info appendString:@" "];
            [display_info appendString:postal];
        }
        
        if(![country isEqualToString:@""]){
            [display_info appendString:@"\n"];
            [display_info appendString:country];
        }

               
        allInfo = [[NSMutableString alloc] initWithFormat:@"Location:"];
        [allInfo appendFormat:@"\n"];
        [allInfo appendFormat:@"%@", display_info];
        [allInfo appendFormat:@"\n\n"];
        [allInfo appendFormat:@"Performing Artists:"];
        [allInfo appendFormat:@"\n"];
        [allInfo appendFormat:@"%@", allArtistsStr];
        

        
        
        
        if(![[event objectForKey:@"website"] isEqualToString:@""]){
            ticketURL = [event objectForKey:@"website"];
        }else{
            if(![[venueInfo objectForKey:@"website"] isEqualToString:@""]){
                ticketURL = [venueInfo objectForKey:@"website"];
            }else{
                ticketURL = @"";
            }
            
        }
    
//        NSLog(@"ticketURL: %@", ticketURL);
        
         
        
        NSString *startDate = [event objectForKey:@"startDate"];

        
        NSString *time = [DateUtil getEventTime:[event objectForKey:@"startDate"]];

        //date for event title
        titleDate = [[NSMutableString alloc] initWithString:[startDate substringToIndex:[startDate length] - 9]];
        [titleDate appendFormat:@"%@", time];

        
        calendar_start_date = [DateUtil stringToDate:startDate];
        
    }
    
    return self;
}

@end
