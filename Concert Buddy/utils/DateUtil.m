//
//  DateUtil.m
//  lasyFmCoreData
//
//  Created by robbie w on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil

+(NSDate *)stringToDate:(NSString *)dateStr{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EE, d LLLL yyyy HH:mm:ss"];
    NSDate *newDate = [dateFormat dateFromString:dateStr];
    
    return newDate;
}

+(NSString *)numberFormattedDate:(NSDate *)aDate{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"dd"];
    NSString *day = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:aDate]];
    
    [dateFormat setDateFormat:@"MM"];
    NSString *mo = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:aDate]];
    
    [dateFormat setDateFormat:@"yyyy"];
    NSString *yr = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:aDate]];
    
    NSMutableString *finalNumDate = [NSMutableString stringWithString:mo];
    [finalNumDate appendString:@"/"];
    [finalNumDate appendString:day];
    [finalNumDate appendString:@"/"];
    [finalNumDate appendString:yr];
    
    return finalNumDate;
}

+(NSString *)getEventTime:(NSString *)aDate{
    

    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EE, d LLLL yyyy HH:mm:ss"];
    NSDate *newDate = [dateFormat dateFromString:aDate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm a"];
    NSString *dateString = [dateFormatter stringFromDate:newDate];

    NSString *timeString = [[NSString alloc] initWithString:dateString];
    
    NSRange range = NSMakeRange(3, 2); 
    
    NSString *min = [timeString substringWithRange:range];

    //if the time is weird dont show it ex: 12:37 AM
    if([min isEqualToString:@"00"] || [min isEqualToString:@"30"]){
        
        

        if([[dateString substringToIndex:1] isEqualToString:@"0" ]){
            
            timeString = [NSString stringWithFormat:@" - %@", [dateString substringFromIndex:1]];

        }else{
            timeString = [NSString stringWithFormat:@" - %@", dateString];
        }
        
    }else{

        timeString = @"";
       
    }
    
    
    return timeString;
    
}

@end
