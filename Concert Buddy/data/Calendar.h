//
//  Calendar.h
//  lasyFmCoreData
//
//  Created by robbie w on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Calendar : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * eventId;

@property (nonatomic, retain) NSDate * calDate;
@property (nonatomic, retain) NSString * calId;



@end
