//
//  ArtistEvent.m
//  last_fm
//
//  Created by robbie w on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ArtistEventData.h"
#import "DateUtil.h"

@implementation ArtistEventData;

@synthesize eventId, city, headLiner, date, shortDate, numberDate;


-(id)initWidthDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        
        NSDictionary *eventDetails = dict;
    
        NSDictionary *venue = [eventDetails objectForKey:@"venue"];
        NSDictionary *locations = [venue objectForKey:@"location"];

        headLiner = [eventDetails valueForKey:@"title"];
        date = [eventDetails valueForKey:@"startDate"];
        eventId = [eventDetails objectForKey:@"id"];
        city= [locations objectForKey:@"city"];
        shortDate = [date substringToIndex:[date length] - 9];
        
        NSDate *newDate = [DateUtil stringToDate:date];
        numberDate = [DateUtil numberFormattedDate:newDate];
        
        
        
    }
    
    return self;
}



@end
