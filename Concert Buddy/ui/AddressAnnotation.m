//
//  AddressAnnotation.m
//  WorkPlus
//
//  Created by Steven 'The Administrator' Baughman on 12/5/11.
//  Copyright (c) 2011 Tender Creative. All rights reserved.
//

#import "AddressAnnotation.h"
#import "EventDetailsData.h"



@implementation AddressAnnotation


@synthesize coordinate, pin_title, coodLat, coodLong;

- (NSString *)subtitle{
	return nil;
}

- (NSString *)title{
	return pin_title;
}

-(id)initWithEventData:(EventDetailsData *)data{



    if(self = [super init]) {
        
        pin_title = data.venueName;
        coodLat = data.latitude;
        coodLong = data.longitude;
        
        
        coordinate.latitude = [coodLat doubleValue];
        coordinate.longitude = [coodLong doubleValue];


    }
	return self;
}


@end
