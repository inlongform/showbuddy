//
//  CoreDataController.m
//  last_fm
//
//  Created by robbie w on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoreDataController.h"
#import "AppDelegate.h"
#import "Favorites.h"
#import "EventDetailsData.h"
#import "DateUtil.h"
#import "Calendar.h"

@implementation CoreDataController

@synthesize context, eventStore;

-(id)init{
    if (self = [super init]) {
        AppDelegate *app_delegate = [UIApplication sharedApplication].delegate;
        context = [app_delegate managedObjectContext];
       
        eventStore = [[EKEventStore alloc] init];

    }
    
    return self;
}

-(void)loadGenres{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *myPListPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"genres.plist"]];
	
	NSFileManager *fileManger = [NSFileManager defaultManager];
    
	
	
	
	if ( ![fileManger fileExistsAtPath:myPListPath] ) {
		NSString *pathToSettingsInBundle = [[NSBundle mainBundle] pathForResource:@"genres" ofType:@"plist"];
		[fileManger copyItemAtPath:pathToSettingsInBundle toPath:myPListPath error:nil];
		
	}
	
	NSString *path = [[NSString alloc] initWithFormat:@"%@/%@", documentsDirectory, @"genres.plist"];
	NSMutableDictionary *genresDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    NSArray *genres = [[NSArray alloc] initWithArray:[genresDict objectForKey:@"genres"]];
    
    [Constants setGenresList:genres];

}





-(void)addFavorite:(NSString *)artist{

   
    NSLog(@"new favorite %@", context);

    NSManagedObject *newFavorite = [NSEntityDescription insertNewObjectForEntityForName:@"Favorites" inManagedObjectContext:context];
    
    [newFavorite setValue:artist forKey:@"name"];
    [context save:nil];
    

}

-(void)removeFavorite:(NSString *)artist{
    

    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Favorites" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(name = %@)",  artist];
    [request setPredicate:pred];
    
    NSManagedObject *matches = nil;
    
    NSArray *objects = [context executeFetchRequest:request error:nil];
     
    if ([objects count] == 0) {
//        NSLog(@"No matches");
    } else {
        
        matches = [objects objectAtIndex:0];
        NSLog(@"%@", matches);
        [context deleteObject:matches];
        [context save:nil];
        NSLog(@"%d matches found", [objects count]);
        
    }
    
}

-(BOOL)searchFavorites:(NSString *)artistName{
    

    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Favorites" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(name = %@)",  artistName];
    [request setPredicate:pred];
    
    
    NSArray *objects = [context executeFetchRequest:request error:nil];
    
    if ([objects count] == 0) {
//        NSLog(@"No matches");
        
        return NO;
    } else {

        
       return YES;
        
    }

}

-(NSMutableArray *)getArtistList{
    
   
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Favorites" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSArray *list = [[NSArray alloc] initWithArray:[context executeFetchRequest:request error:nil]];
    NSMutableArray *artistList = [[NSMutableArray alloc] init];
    
    
    
    for(int i = 0; i < [list count]; i++){
        Favorites *favorite = [list objectAtIndex:i];
        
        [artistList addObject:favorite.name];
    }
    
    //alphabatize list
    
    NSMutableArray *sortedArtistList = [[NSMutableArray alloc] initWithArray:[artistList sortedArrayUsingSelector:@selector(compare:)]];
    
    
    return sortedArtistList;
    
}

//events///////////////////////////////////////////////


-(void)addEventToCalendar:(EventDetailsData *)eventDetails artist:(NSString *)selectedArtist{
    
    //save to calendar

    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
    event.calendar = [eventStore defaultCalendarForNewEvents];
    
    NSLog(@"save selected artist to Calendar: %@", selectedArtist);
    
    int fourHrs = 14400;
    
    NSDate *endDate = [[NSDate alloc] initWithTimeInterval:fourHrs sinceDate:eventDetails.calendar_start_date];
    
    event.title     = selectedArtist;
    event.location  = eventDetails.venueName;
    event.notes     = eventDetails.allInfo;
    event.startDate = eventDetails.calendar_start_date;
    event.endDate   = endDate;
    event.allDay    = NO;
   
    [eventStore saveEvent:event span:EKSpanThisEvent error:nil];
    
    
    //if the id is already saved in core data
    NSArray *array = [self getCoreCalendarItemsWithId:eventDetails.eventId];
    
    if([array count] > 0){
        //the event is already in core data
        for(int i = 0 ; i < [array count]; i++){
            Calendar *item = [array objectAtIndex:i];
            [context deleteObject:item];
            [context save:nil];
            
        }
    }
    


    
    //save to coredata
    NSManagedObject *newCalendarItem = [NSEntityDescription insertNewObjectForEntityForName:@"Calendar" inManagedObjectContext:context];
    
    
    [newCalendarItem setValue:selectedArtist forKey:@"name"];
    [newCalendarItem setValue:eventDetails.eventId forKey:@"eventId"];
    [newCalendarItem setValue:event.eventIdentifier forKey:@"calId"];
    [newCalendarItem setValue:eventDetails.calendar_start_date forKey:@"calDate"];

    [context save:nil];
    
//    [self getCalendarEventList];
    
    
}

-(void)removeEventWithEventId:(NSString *)eventId{

    NSArray *objects = [self getCoreCalendarItemsWithId:eventId];
    
    Calendar *coreCalEvt = [objects objectAtIndex:0];
    EKEvent *matchedEvent = [eventStore eventWithIdentifier:coreCalEvt.calId];
    

    
    [self removeEventFromCalendar:matchedEvent];
}



-(void)removeEventFromCalendar:(EKEvent *)savedEvent{
    
    
    //remove from coredata
    
    Calendar *match = [self getCoreCalendarItemWithEvent:savedEvent];
    [context deleteObject:match];
    [context save:nil];
    
    //remove from calendar

    
    

    [eventStore removeEvent:savedEvent span:EKSpanThisEvent error:nil];
    
    [self getCalendarEventList];


}





-(NSMutableArray *)getCalendarEventList{
    
    
    NSMutableArray *events = [[NSMutableArray alloc] init];
    
    
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Calendar" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSArray *objects = [context executeFetchRequest:request error:nil];
    
    //get today at midnight
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]];
    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];
    
    NSDate *midnightUTC = [calendar dateFromComponents:dateComponents];
    
//    NSLog(@"midnightUTC %@", midnightUTC);
 
    
    for(int i = 0; i < [objects count]; i++){
        
        Calendar *coreItem = [objects objectAtIndex:i];
        
        EKEvent *matchedEvent = [eventStore eventWithIdentifier:coreItem.calId];
        
        
        if(matchedEvent != nil){
            
            
            NSComparisonResult result = [midnightUTC compare:matchedEvent.startDate];
           
            
            //get only dates starting today
            if(result == NSOrderedAscending){
                [events addObject:matchedEvent];
                NSLog(@"CoreDataController - matched event %@ %@ %@", matchedEvent.startDate, matchedEvent.title, matchedEvent.endDate);
            }

        }
         
        
    }
    

    //sort by date
    [events sortUsingSelector:@selector(compareStartDateWithEvent:)];
    
    NSLog(@"CoreDataController -  all events: %@", events);
    NSLog(@"////////////////");
    return events;
    
    
}

-(NSString *)getSelectedEventId:(EKEvent *)event{

    
    Calendar *coreCalEvt = [self getCoreCalendarItemWithEvent:event];
    
    return coreCalEvt.eventId;
    


}



-(BOOL)searchCalendarEvents:(NSString *)eventId{
    
    

    
    NSArray *objects = [self getCoreCalendarItemsWithId:eventId];
    

    
    if ([objects count] == 0) {
        NSLog(@"No matches");
        
        return NO;
    } else {
        Calendar *coreCalItem = [objects objectAtIndex:0];
        
        NSString *coreCalId = coreCalItem.calId;

        
        //get the calendar event from the coredata calId
        EKEvent *matchedEvent = [eventStore eventWithIdentifier:coreCalId];
        

        
        if(matchedEvent != nil){
            return YES;
        }else{
            return NO;
        }
       
    }

    
}

//event utils//////////////////////////////////////////////////////////////////////

-(NSArray *)getCoreCalendarItemsWithId:(NSString *)eventId{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Calendar" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(eventId = %@)",  eventId];
    [request setPredicate:pred];
     
    NSArray *objects = [context executeFetchRequest:request error:nil];
    
    
    return objects;
}


-(Calendar *)getCoreCalendarItemWithEvent:(EKEvent *)event{
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Calendar" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(calId = %@)",  event.eventIdentifier];
    [request setPredicate:pred];
    
    
    NSArray *objects = [context executeFetchRequest:request error:nil];
    
    Calendar *coreItem = [objects objectAtIndex:0];
    
    return coreItem;
    
}



@end
