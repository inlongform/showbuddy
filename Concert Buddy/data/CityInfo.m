//
//  CityInfo.m
//  Show Buddy
//
//  Created by robbie w on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CityInfo.h"

@implementation CityInfo

@synthesize latitude, longitude, city_name, distance;

-(id)initWithLat:(NSString *)lat longitude:(NSString *)lon andName:(NSString *)name{
    
    if (self = [super init]) {
        latitude = [lat doubleValue];
        longitude = [lon doubleValue];
        city_name = name;
        
        
    }
    
    return self;
    
}

-(void)setDistance:(double)dist{
    distance = dist;
}

-(void)traceDistance{
    NSLog(@"%f", distance);
}

-(NSString *)getCityName{
    return city_name;
}

-(double)getLatitude{
    return latitude;
}



-(double)getlongitude{
    return longitude;
}

@end
