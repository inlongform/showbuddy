//
//  DateUtil.h
//  lasyFmCoreData
//
//  Created by robbie w on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject{
    
}

+(NSDate *)stringToDate:(NSString *)dateStr;
+(NSString *)numberFormattedDate:(NSDate *)aDate;
+(NSString *)getEventTime:(NSString *)aDate;

@end
