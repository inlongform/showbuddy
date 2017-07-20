//
//  EventDetailsData.h
//  last_fm
//
//  Created by robbie w on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventDetailsData : NSObject



@property (strong, nonatomic)NSMutableArray *allArtists;
@property (strong, nonatomic)NSMutableString *allInfo;
@property (strong, nonatomic)NSString *headLiner;
@property (strong, nonatomic)NSString *venueName;
@property (strong, nonatomic)NSString *venueId;
@property (strong, nonatomic)NSMutableString *titleDate;
@property (strong, nonatomic)NSString *latitude;
@property (strong, nonatomic)NSString *longitude;
@property (strong, nonatomic)NSString *eventId;
@property (strong, nonatomic)NSDate *calendar_start_date;
@property (strong, nonatomic)NSMutableString *display_info;
@property (strong, nonatomic)NSURL *eventURL;
@property (strong, nonatomic)NSString *phoneNumber;
@property (strong, nonatomic)NSString *ticketURL;






-(id)initWithDataDictionary:(NSDictionary *)dict eventURL:(NSURL *)url;

@end
