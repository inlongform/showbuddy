//
//  AddressAnnotation.h
//  WorkPlus
//
//  Created by Steven 'The Administrator' Baughman on 12/5/11.
//  Copyright (c) 2011 Tender Creative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class EventDetailsData;

@interface AddressAnnotation : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *pin_title;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSString *coodLat;
@property (strong, nonatomic) NSString *coodLong;

-(id)initWithEventData:(EventDetailsData *)data;

@end
