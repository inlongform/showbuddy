//
//  Constants.h
//  last_fm
//
//  Created by robbie w on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@interface Constants : NSObject

+(CGRect) defaultFrame;

//location
+(void) setlocationWithLat:(float)lat andLongitude:(float)longitude;
+(CLLocation *) getlocationLatLong;
+(void)setCurrentCity:(NSString *)city;
+(void)setClosestCity:(NSString *)cityName;
+(NSString *)getCurrentCity;

//urls
+(NSString *)getShowsURL;
+(NSString *)getShowsURLWithLatLong;
+(NSString *)getEventURL;
+(NSString *)getArtistEventInfoURL;
+(NSString *)getArtistInfoURL;
+(NSString *)baseConnectionURL;
+(NSString *)getItunesURL;
+(NSString *)getHelv;

+(void)setRadius:(int)rad;
+(NSString *)getRadius;

+(void)setGenresList:(NSArray *)array;
+(NSArray *)getGenresList;

+(void)setGenre:(NSString *)str;
+(NSString *)getGenre;









@end
