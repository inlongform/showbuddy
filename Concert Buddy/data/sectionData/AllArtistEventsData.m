//
//  AllArtistEventsData.m
//  lasyFmCoreData
//
//  Created by robbie w on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AllArtistEventsData.h"
#import "DateUtil.h"

@implementation AllArtistEventsData

@synthesize eventId, shortDate, city, country, latitude, longitude, eventInfo;

-(id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        
        NSDictionary *events = dict;

        
        NSDictionary *venue = [events objectForKey:@"venue"];
        NSDictionary *locations = [venue objectForKey:@"location"];
        NSString *eventDate = [events objectForKey:@"startDate"];
        
        city = [locations objectForKey:@"city"];
        country = [locations objectForKey:@"country"];
        
        eventId = [events objectForKey:@"id"];
        
        NSRange range = NSMakeRange(5, 12);
        
        shortDate = [eventDate substringWithRange:range];
        
        NSObject *geo = [locations objectForKey:@"geo:point"];
        latitude = [geo valueForKey:@"geo:lat"];
        longitude = [geo valueForKey:@"geo:long"];
        
        NSDate *newDate = [DateUtil stringToDate:eventDate];
        NSString *numberDate = [DateUtil numberFormattedDate:newDate];
        
        
        
        eventInfo = [NSMutableString stringWithString:numberDate];
        [eventInfo appendString:@" "];
        [eventInfo appendString:city];
        [eventInfo appendString:@", "];
        [eventInfo appendString:country];
        
//        
//        NSLog(@"%@ %@", latitude, longitude);
//        NSLog(@"%@", city);
//        NSLog(@"%@", country);
//        NSLog(@"%@", eventId);
//        NSLog(@"%@", shortDate);
//        NSLog(@"%@", eventInfo);
//        NSLog(@"=====================");
//        NSLog(@" ");
    }

    
    return self;

}

@end
