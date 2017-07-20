//
//  AllArtistEventsData.h
//  lasyFmCoreData
//
//  Created by robbie w on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllArtistEventsData : NSObject

@property (strong, nonatomic) NSString *eventId;
@property (strong, nonatomic) NSString *shortDate;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSMutableString *eventInfo;

-(id)initWithDictionary:(NSDictionary *)dict;

@end
