//
//  DistanceUtil.m
//  Show Buddy
//
//  Created by robbie w on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DistanceUtil.h"
#import "CityInfo.h"

@interface DistanceUtil()



+(NSArray *)getCityArray;

@end



@implementation DistanceUtil



+(NSString *)getClosestCityWith:(double)lat andLong:(double)lon{
    
    NSArray *locations = [DistanceUtil getCityArray];

    double earthsRadius = 3956.087107103049;
    
    double latitude1Radians = (lat / 180) * M_PI;
    double longitude1Radians = (lon / 180) * M_PI;
    

    
    for(int i = 0; i < [locations count]; i++){

        CityInfo *cityInfo = [locations objectAtIndex:i];
        
        double lat1 = [cityInfo getLatitude];
        double lon1 = [cityInfo getlongitude];
        
        double latitude2Radians = (lat1 / 180) * M_PI;
        double longitude2Radians = (lon1 / 180) * M_PI;
        
        
        double distance = (earthsRadius * 2) * asin(sqrt(pow(sin((latitude1Radians - latitude2Radians) / 2), 2) + cos(latitude1Radians) * cos(latitude2Radians) * pow(sin((longitude1Radians - longitude2Radians) / 2), 2)));
        
        [cityInfo setDistance:distance];
        
        
    }
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES] ;

    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [locations sortedArrayUsingDescriptors:sortDescriptors];
    

    
    
    CityInfo *info = [sortedArray objectAtIndex:0];
    

    
    return info.getCityName;
}

+(NSArray *)getCityArray{
    
    NSArray *cityArray = [[NSArray alloc] initWithObjects:@"new york", @"boston", @"chicago", @"atlanta", @"los angeles", @"san francisco", @"las vegas", @"seattle", @"minneapolis", @"charlotte", @"columbus", @"dallas", @"austin", @"houston", @"detroit", @"san diego", @"philadelphia", @"miami", nil];
    
    NSArray *latArray = [[NSArray alloc] initWithObjects:@"40.7142", @"42.3583", @"41.8500", @"33.7489", @"34.0522", @"37.7750", @"36.0800", @"47.6097", @"44.9800", @"35.2269", @"39.9611", @"32.7828", @"30.2669", @"29.7631", @"42.3314", @"32.7153", @"39.9522", @"25.7933", nil];
    
    NSArray *longArray = [[NSArray alloc] initWithObjects:@"-74.0064", @"-71.0603", @"-87.6500", @"-84.3881", @"-118.2428", @"-122.4183", @"-115.1522", @"-122.3331", @"-93.2636", @"-80.8433", @"-82.9989", @"-96.8039", @"-97.7428", @"-95.3631", @"-83.0458", @"-117.1564", @"-75.1642", @"-80.2906", nil];
    
    NSMutableArray *locationsArray = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [cityArray count]; i++){
        
        CityInfo *cityInfo = [[CityInfo alloc] initWithLat:[latArray objectAtIndex:i] longitude:[longArray objectAtIndex:i] andName:[cityArray objectAtIndex:i]];
        
        [locationsArray addObject:cityInfo];
        
    }
    
    return locationsArray;
    
}



@end
