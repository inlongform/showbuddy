//
//  EventArtistsTableView.h
//  last_fm
//
//  Created by robbie w on 3/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class EventDetailsData, DataController, CoreDataController;

@interface EventDetailsView : UITableViewController<MKMapViewDelegate, CLLocationManagerDelegate>



- (id)initWithStyle:(UITableViewStyle)style artistData:(EventDetailsData *)eventData title:(NSString *)selected;

@end
