//
//  BrowseCity.h
//  last_fm
//
//  Created by robbie w on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataController, ArtistEventData;

@interface BrowseCity : UITableViewController <UIScrollViewDelegate, UITableViewDelegate>

- (id)initWithStyle:(UITableViewStyle)style andEvents:(NSMutableArray *)cityEvents isCurrentLocation:(Boolean)isCurrent;



@end
