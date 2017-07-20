//
//  AllArtistEventsView.h
//  lasyFmCoreData
//
//  Created by robbie w on 3/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractTableViewController.h"

@class DataController;

@interface AllArtistEventsView : AbstractTableViewController



- (id)initWithStyle:(UITableViewStyle)style eventsData:(NSArray *)events title:(NSString *)artistTitle;

@end
