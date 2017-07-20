//
//  Constants.m
//  last_fm
//
//  Created by robbie w on 2/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <CoreLocation/CLLocation.h>
#import "Constants.h"

@implementation Constants

CLLocation *userLocation;
NSString *currentCity;
NSString *closestCity;
NSString *radius;
NSString *genre;
NSArray *genreList;


+(CGRect) defaultFrame {
    return CGRectMake(0, 0, [UIScreen mainScreen].applicationFrame.size.width, [UIScreen mainScreen].applicationFrame.size.height + 20);
}

//location data
+(void) setlocationWithLat:(float)lat andLongitude:(float)longitude{
//    NSLog(@"lat: %f, long: %f", lat, longitude);
    userLocation = [[CLLocation alloc] initWithLatitude:lat longitude:longitude];
}
+(CLLocation *) getlocationLatLong{
    return userLocation;
}

+(void)setCurrentCity:(NSString *)city{
    currentCity = city;
}

+(NSString *)getCurrentCity{
    return currentCity;
}

+(void)setClosestCity:(NSString *)cityName{
    closestCity = cityName;
}

+(NSString *)getHelv{
    return @"HelveticaNeueLTStd-BdCn";
}

+(void)setRadius:(int)rad {
    
    int distanceKm = rad / 0.62137;    
    radius = [[NSNumber numberWithInt:distanceKm] stringValue];

}

+(NSString *)getRadius{
    return radius;
}

+(void)setGenresList:(NSArray *)array{
    genreList = array;
}
+(NSArray *)getGenresList{
    return genreList;
}

+(void)setGenre:(NSString *)str {
    genre = str;
}
+(NSString *)getGenre {
    return genre;
}


//urls
+(NSString *)getShowsURL{
    return @"http://ws.audioscrobbler.com/2.0/?method=geo.getevents&format=json&location=CITYNAME&page=PAGENUM&limit=20&distance=DISTANCE&api_key=5c00f46d0340278f2d16407b5a8ca34a";
}

+(NSString *)getShowsURLWithLatLong{
    return @"http://ws.audioscrobbler.com/2.0/?method=geo.getevents&format=json&lat=LATITUDE&long=LONGITUDE&page=PAGENUM&distance=DISTANCE&&limit=20&api_key=5c00f46d0340278f2d16407b5a8ca34a";
}
+(NSString *)getEventURL{
    return @"http://ws.audioscrobbler.com/2.0/?method=event.getinfo&format=json&event=EVENTID&api_key=5c00f46d0340278f2d16407b5a8ca34a";
}
+(NSString *)getArtistEventInfoURL{
    return @"http://ws.audioscrobbler.com/2.0/?method=artist.getevents&format=json&artist=ARTIST&api_key=5c00f46d0340278f2d16407b5a8ca34a";
}
+(NSString *)getArtistInfoURL{
    return @"http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&format=json&artist=ARTIST&autocorrect=1&api_key=5c00f46d0340278f2d16407b5a8ca34a";
}

+(NSString *)baseConnectionURL{
    return @"http://ws.audioscrobbler.com";
}

+(NSString *)getItunesURL{
    return @"http://itunes.apple.com/search?term=ARTIST&entity=song&limit=15";
}








@end
