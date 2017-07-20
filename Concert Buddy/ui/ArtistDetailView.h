//
//  ArtistDetailView.h
//  last_fm
//
//  Created by robbie w on 3/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>



@class ArtistDetailData, DataController, CoreDataController;

@interface ArtistDetailView : UITableViewController




- (id)initWithStyle:(UITableViewStyle)style artistData:(ArtistDetailData *)data;

@end
