//
//  CityInfo.h
//  Show Buddy
//
//  Created by robbie w on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityInfo : NSObject

@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) double distance;
@property (strong, nonatomic) NSString *city_name;


-(id)initWithLat:(NSString *)lat longitude:(NSString *)lon andName:(NSString *)name;

-(NSString *)getCityName;
-(double)getLatitude;
-(double)getlongitude;
-(void)traceDistance;
-(void)setDistance:(double)dist;

@end
