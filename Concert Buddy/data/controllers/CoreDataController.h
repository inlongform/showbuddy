//
//  CoreDataController.h
//  last_fm
//
//  Created by robbie w on 3/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>


@class EventDetailsData, Calendar;

@interface CoreDataController : NSObject

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) EKEventStore *eventStore;
@property (strong, nonatomic) NSArray *genres;







-(void)addFavorite:(NSString *)artist;
-(void)removeFavorite:(NSString *)artist;
-(BOOL)searchFavorites:(NSString *)artistName;
-(NSMutableArray *)getArtistList;

-(void)addEventToCalendar:(EventDetailsData *)eventDetails artist:(NSString *)selectedArtist;

-(void)removeEventFromCalendar:(EKEvent *)savedEvent;
-(NSMutableArray *)getCalendarEventList;

-(NSString *)getSelectedEventId:(EKEvent *)event;
-(void)removeEventWithEventId:(NSString *)eventId;

-(Calendar *)getCoreCalendarItemWithEvent:(EKEvent *)event;
-(NSArray *)getCoreCalendarItemsWithId:(NSString *)eventId;


-(BOOL)searchCalendarEvents:(NSString *)eventId;

-(void)loadGenres;






@end
