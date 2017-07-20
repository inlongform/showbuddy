//
//  ArtistEvent.h
//  last_fm
//
//  Created by robbie w on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArtistEventData : NSObject




@property (strong, nonatomic)NSString *eventId;
@property (strong, nonatomic)NSString *city;
@property (strong, nonatomic)NSString *headLiner;
@property (strong, nonatomic)NSString *date;
@property (strong, nonatomic)NSString *shortDate;
@property (strong, nonatomic)NSString *numberDate;


-(id)initWidthDictionary:(NSDictionary *)dict;


@end
